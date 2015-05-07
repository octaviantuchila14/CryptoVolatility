class AddPredictionDaysToNeuralNetwork < ActiveRecord::Migration
  def change
    add_column :neural_networks, :prediction_days, :integer
  end
end