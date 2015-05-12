class RemoveDateFromExchangeRates < ActiveRecord::Migration
  def change
    remove_column :exchange_rates, :date
  end
end
