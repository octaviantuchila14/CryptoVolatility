class Currency < ActiveRecord::Base
  validates :name, presence: true
  validates :full_name, presence: true
  validates_uniqueness_of :name
  has_one :neural_network, inverse_of: :currency
  has_many :exchange_rates

  self.after_initialize do
    #create a neural network corresponding to the currency
    if(self.neural_network == nil)
      create_neural_network
    end
  end

=begin
  #returns prediction for a number of days after
  def predict(days_after, market, reference_currency)
    crypto_prices = ExchangeRate.where(cr: self.name, ref_cr: reference_currency)
    crypto_prices.sort_by(:Date)

    beta = market.get_beta(crypto_prices)
    market_rate = market.expected_return
    risk_free_rate = market.risk_free_rate
    #estimate returns for each of the f
    (1..days_after.size) do
      expected_price = financial_model.predict(beta, market_rate, risk_free_rate)
      capm_prices << financial_model
    end

    #get all market values from the days starting from which we have Bitcoin prices
    #assumes the market data is older than the cryptocurrency data
    market_value = ExchangeRate.where(cr: '^GSPC', ref_cr: 'usd', id: crypto_prices.last.date..Date::INFINITY)
    market_value.sort_by(:Date)
    #get CAPM predictions for the dates
=end

end
