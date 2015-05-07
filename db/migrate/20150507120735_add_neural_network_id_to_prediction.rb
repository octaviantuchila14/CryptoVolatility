class AddNeuralNetworkIdToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :neural_network_id, :integer
  end
end
