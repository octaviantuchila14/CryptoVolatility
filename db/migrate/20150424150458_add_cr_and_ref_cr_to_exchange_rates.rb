class AddCrAndRefCrToExchangeRates < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :cr, :string
    add_column :exchange_rates, :ref_cr, :string
  end
end
