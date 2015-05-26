require 'statsample'

class Market < ActiveRecord::Base
  has_one :neural_network, as: :predictable
  has_one :prediction, as: :predictable

  has_many :exchange_rates, as: :predictable
  has_many :currencies

  has_one :submarket, class_name: "Market", foreign_key: :supermarket_id
  belongs_to :supermarket, class_name: "Market", foreign_key: :supermarket_id

  self.after_initialize do
    #get quotes for american market
    #rake query_api:get_market_data
  end

  def get_variation(size)
    variations = []
    exchange_rates = self.exchange_rates.where(predicted: false).sort_by{|er| er.date}.last(size)
    exchange_rates.each_index do |index|
      if(index + 1 < exchange_rates.size)
        variations << (exchange_rates[index + 1].last - exchange_rates[index].last)/exchange_rates[index].last
      end
    end
    variations
  end

  def get_expected_returns(exchange_rates)
    ers = []
    exchange_rates.each_index do |index|
      if(index + 1 < exchange_rates.size)
        ers << (exchange_rates[index + 1].last - exchange_rates[index].last)/exchange_rates[index].last
      end
    end
    ers
  end

  def get_beta(cr_val, mr_val)

    cov = Statsample::Bivariate.covariance(cr_val, mr_val)
    var = mr_val.variance_population

    if(var != 0)
      beta = cov/var
    elsif(cov == 0)
      beta = 1
    else
      raise "Impossible: variance 0, covariance bigger than 0"
    end
    beta
  end


  def capm_prediction(currency)
    cr_var = currency.get_variation.to_scale
    mr_var = get_variation(cr_var.size + 1).to_scale
    last_date = Date.today - cr_var.size.days

    beta = get_beta(cr_var, mr_var)
    expected_returns = get_expected_returns(currency.exchange_rates)

    predicted_ex_rates = []
    expected_returns.each_index do |i|
      currency_rate = currency.exchange_rates.find_by(date: last_date + (i - 1).days)
      if(currency_rate != nil) #taking into account weekends
        value = self.risk_free_rate + beta*(expected_returns[i] - risk_free_rate)
        predicted_ex_rates << ExchangeRate.create(last: currency_rate.last*(1 + value), date: last_date + i.days, predicted: true)
      end
    end
    predicted_ex_rates
  end


  def illiquidity_prediction(currency)
    ill_premium = self.last_expected_return - self.submarket.last_expected_return

    size = currency.exchange_rates.size

    ill_beta = get_beta(currency.exchange_rates.collect{|er| er.volume}.to_scale,
                        self.exchange_rates.last(size).collect{|er| er.volume}.to_scale)

    capm_pred = capm_prediction(currency)
    #we add illiquidity factor to the capm
    capm_pred.each do |er|
      er.last += ill_premium * ill_beta
    end
    capm_pred
  end

  def last_expected_return
    last_two_ers = self.exchange_rates.last(2)
    (last_two_ers[1].last - last_two_ers[0].last)/last_two_ers[0].last
  end

end
