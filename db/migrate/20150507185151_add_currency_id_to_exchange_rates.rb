class AddCurrencyIdToExchangeRates < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :currency_id, :integer
  end
end
