require 'descriptive_statistics'

class Market < ActiveRecord::Base

  def get_mean
    get_exchange_rates.mean
  end

  def get_volatility
    get_exchange_rates.standard_deviation
  end

  private
  def get_exchange_rates
    market_data = ExchangeRate.where(subject: self.name)
    #compute differences between 2 consecutive days
    lastValues = market_data.map{ |elem| elem[:last] }
    lastValues.each_cons(2).to_a.map { |elem| elem[0] - elem[1]}
  end

end
