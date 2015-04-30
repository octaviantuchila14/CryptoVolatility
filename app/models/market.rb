class Market < ActiveRecord::Base

  def get_mean
    @market_data = ExchangeRate.find_by_subject(@market.name)
    @market_data.mean
  end

  def get_volatility
    @market_data = ExchangeRate.find_by_subject(@market.name)
    @market_data.sd
  end

end
