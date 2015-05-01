require 'statsample'

class Market < ActiveRecord::Base

  def get_mean
    get_exchange_rates.mean
  end

  def get_volatility
    get_exchange_rates.standard_deviation_population
  end

  def get_variance
    sd = get_volatility
    sd * sd
  end

  def get_covariance(asset_rates = nil)
    market_rates = get_exchange_rates
    asset_rates = asset_rates.to_scale
    #make vectors have same size
    if(asset_rates.size > market_rates.size)
      asset_rates = asset_rates.last(market_rates.size)
    end
    if(asset_rates.size < market_rates.size)
      market_rates = market_rates.last(asset_rates.size)
    end
    p asset_rates
    p market_rates
    p "covariance is:"
    p Statsample::Bivariate.covariance(market_rates, asset_rates)
    Statsample::Bivariate.covariance(market_rates, asset_rates)
  end

  def get_beta(asset_rates = nil)
    get_covariance(asset_rates)/get_variance
  end

  private
  def get_exchange_rates
    market_data = ExchangeRate.where(subject: self.name)
    #compute differences between 2 consecutive days
    lastValues = market_data.map{ |elem| elem[:last] }
    dataset = lastValues.each_cons(2).to_a.map { |elem| elem[1] - elem[0]}
    p dataset
    dataset.to_scale
  end

end
