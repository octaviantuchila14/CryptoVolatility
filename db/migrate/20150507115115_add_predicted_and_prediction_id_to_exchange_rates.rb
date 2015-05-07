class AddPredictedAndPredictionIdToExchangeRates < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :predicted, :boolean
    add_column :exchange_rates, :prediction_id, :integer
  end
end
