class RemoveDateFromExchangeRates < ActiveRecord::Migration
  def change
    remove_column :exchange_rates, :date
    remove_column :exchange_rates, :time
    add_column    :exchange_rates, :time, :datetime
  end
end
