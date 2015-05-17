require 'statsample'

class Market < ActiveRecord::Base
  has_one :neural_network, as: :predictable
  has_one :prediction, as: :predictable
  has_many :exchange_rates, as: :predictable
  has_many :currencies

  self.after_initialize do
    #get quotes for american market
    #rake query_api:get_market_data
  end

  def get_variation(size)
    variations = []
    exchange_rates = self.exchange_rates.where(predicted: false).sort_by{|er| er.date}.last(size)
    exchange_rates.each_index do |index|
      if(index + 1 < exchange_rates.size)
        variations << (exchange_rates[index + 1].last - exchange_rates[index].last)
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

  def get_beta(cr_var, mr_var)
    var = mr_var.variance_population
    cov = Statsample::Bivariate.covariance(cr_var, mr_var)

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
    expected_returns.each do |i|
      value = self.risk_free_rate + beta*(expected_returns[i] - risk_free_rate)
      currency_rate = currency.exchange_rates.find_by(date: last_date + (i - 1).days)
      predicted_ex_rates << ExchangeRate.new(last: currency_rate.last*(1 + value), date: last_date + i.days, predicted: true)
    end
    predicted_ex_rates
  end

end
