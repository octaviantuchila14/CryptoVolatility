class AddPredictableToExchangeRates < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :predictable_id, :integer
    add_column :exchange_rates, :predictable_type, :string
  end
end
