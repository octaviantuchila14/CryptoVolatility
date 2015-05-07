class MovePredictionDaysToCurrency < ActiveRecord::Migration
  def change
    remove_column :neural_networks, :prediction_days
    add_column :currencies, :prediction_days, :integer
  end
end
