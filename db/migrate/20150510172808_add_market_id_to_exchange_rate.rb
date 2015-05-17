class AddMarketIdToExchangeRate < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :market_id, :integer
  end
end
