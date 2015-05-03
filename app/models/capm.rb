class Capm < ActiveRecord::Base

  def valuate_asset(asset_rates = nil, market)
    rm = market.get_mean
    beta = market.get_beta(asset_rates)
    rm*beta
  end

end
