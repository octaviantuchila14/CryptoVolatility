require 'statsample'

class Currency < ActiveRecord::Base
  validates :name, presence: true
  validates :full_name, presence: true
  validates_uniqueness_of :name
  has_one :neural_network, inverse_of: :currency
  has_one :prediction
  has_many :exchange_rates
  belongs_to :market

  enum prediction_type: [:neural_network, :capm]

  self.after_initialize do
    #create a neural network corresponding to the currency
    if(self.neural_network == nil)
      create_neural_network
    end

    if(self.market == nil)
      if(Market.all.size == 0)
        create_market(name: :"^GSPC")
      else
        self.market = Market.first
      end
    end

  end

  def get_variation
    variations = []
    exchange_rates = self.exchange_rates.where(predicted: false).sort_by{|er| er.time}
    exchange_rates.each_index do |index|
      if(index + 1 < exchange_rates.size)
        variations << (exchange_rates[index + 1].last - exchange_rates[index].last)
      end
    end
    variations
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
