class AddPredictableIdAndPredictableTypeToNeuralNetwork < ActiveRecord::Migration
  def change
    remove_column :neural_networks, :currency_id
    add_column :neural_networks, :predictable_id, :integer
    add_column :neural_networks, :predictable_type, :string
  end
end
