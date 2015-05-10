class Market < ActiveRecord::Base
  has_many :exchange_rates

  self.after_initialize do
    #get quotes for american market
    #rake query_api:get_market_data
  end

  def get_capm

  end

end
