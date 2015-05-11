class Market < ActiveRecord::Base
  has_many :exchange_rates
  has_many :predictions

  self.after_initialize do
    #get quotes for american market
    #rake query_api:get_market_data
  end

  def get_beta(currency)
    cr_var = currency.get_variation

  end

  def capm_prediction

  end

end
