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


  def capm_prediction(currency, additional_value = 0)
    cr_var = currency.get_variation.to_scale
    mr_var = get_variation(cr_var.size + 1).to_scale

    begin_date = currency.exchange_rates.sort_by {|er| er.date}.first.date
    end_date = currency.exchange_rates.sort_by {|er| er.date}.last.date

    beta = get_beta(cr_var, mr_var)
    expected_returns = get_expected_returns(currency.exchange_rates)

    predicted_ex_rates = []
    k = 0 #iterates through exchange rates, which are not available in the weekend
    (0..(end_date - begin_date)).each do |i|
      currency_rate = currency.exchange_rates.find_by(date: begin_date + i.days)
      if(currency_rate != nil) #taking into account weekends
        value = self.risk_free_rate + beta*(expected_returns[k] - risk_free_rate)
        predicted_ex_rates << ExchangeRate.create(last: currency_rate.last*(1 + value + additional_value), date: begin_date + i.days, predicted: true)
        k = k + 1
        break if(k == expected_returns.size)
      end
      pp "value is #{value} while additional value is #{additional_value}"
    end

    predicted_ex_rates
  end


  def illiquidity_prediction(currency)
    ill_premium = 100*(self.last_expected_return - self.submarket.last_expected_return)

    size = currency.exchange_rates.size

    ill_beta = get_beta(currency.exchange_rates.collect{|er| er.volume}.to_scale,
                        self.exchange_rates.last(size).collect{|er| er.volume}.to_scale)

    v = capm_prediction(currency, ill_premium*ill_beta)

    pp "ill_beta is #{ill_beta} and ill_premium is #{ill_premium}"
    pp "the market return is #{self.last_expected_return} while the submarket return is #{self.submarket.last_expected_return}"
    v
  end

  def last_expected_return
    last_two_ers = self.exchange_rates.last(2)
    (last_two_ers[1].last - last_two_ers[0].last)/last_two_ers[0].last
  end

end
