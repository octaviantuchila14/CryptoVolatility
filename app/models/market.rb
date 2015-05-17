require 'statsample'

class Market < ActiveRecord::Base
  has_many :exchange_rates
  has_one :neural_network, as: :predictable
  has_one :prediction, as: :predictable

  self.after_initialize do
    #get quotes for american market
    #rake query_api:get_market_data
  end

  def get_variation(size)
    variations = []
    exchange_rates = self.exchange_rates.where(predicted: false).sort_by{|er| er.time}.last(size)
    exchange_rates.each_index do |index|
      if(index + 1 < exchange_rates.size)
        variations << (exchange_rates[index + 1].last - exchange_rates[index].last)
      end
    end
    variations
  end

  def get_expected_returns(mr_var)
    ers = []
    mr_var.each_index do |index|
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
    expected_returns = et_expected_return(mr_var)

    predicted_ex_rates = []
    expected_returns.each do |i|
      value = self.risk_free_rate + beta*(expected_returns[i] - risk_free_rate)
      predicted_ex_rates << ExchangeRate.new(last: value, date: last_date + i.days)
    end
    predicted_ex_rates
  end

end
