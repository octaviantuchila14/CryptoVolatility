require 'statsample'

class Market < ActiveRecord::Base
  has_many :exchange_rates
  has_many :predictions

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

  def get_beta(currency)
    cr_var = currency.get_variation.to_scale
    mr_var = get_variation(cr_var.size + 1).to_scale

    var = mr_var.variance_population
    cov = Statsample::Bivariate.covariance(cr_var, mr_var)

    if(var != 0)
      beta = cov/var
    elsif(cov == 0)
      beta = 1
    else
      raise "Impossible: variance 0, covariance bigger than 0"
    end
  end

  def capm_prediction(currency)
    self.risk_free_rate + get_beta(currency)*(market_expected_return - risk_free_rate)
  end

end
