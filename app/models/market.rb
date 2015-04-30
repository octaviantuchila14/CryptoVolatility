require 'descriptive_statistics'

class Market < ActiveRecord::Base

  def get_mean
    market_data = ExchangeRate.where(subject: self.name)
    dataset = market_data.map{ |elem| elem[:last] }
    dataset.mean
  end

  def get_volatility
    market_data = ExchangeRate.where(subject: self.name)
    dataset = market_data.map{ |elem| elem[:last] }
    dataset.standard_deviation
  end

end
