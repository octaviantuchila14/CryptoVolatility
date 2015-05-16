class AddDateToExchangeRates < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :date, :date
  end
end
