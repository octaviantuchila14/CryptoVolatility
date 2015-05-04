class Currency < ActiveRecord::Base
  validates :name, presence: true
  validates :full_name, presence: true

  def predict
    crypto_prices = ExchangeRate.where(cr: 'btc', ref_cr: 'usd')
    crypto_prices.sort_by(:Date)

=begin
    #get all market values from the days starting from which we have Bitcoin prices
    #assumes the market data is older than the cryptocurrency data
    market_value = ExchangeRate.where(cr: '^GSPC', ref_cr: 'usd', id: crypto_prices.last.date..Date::INFINITY)
    market_value.sort_by(:Date)
    #get CAPM predictions for the dates
=end

  end

end
