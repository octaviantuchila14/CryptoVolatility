class AddCurrencyIdToNeuralNetwork < ActiveRecord::Migration
  def change
    add_column :neural_networks, :currency_id, :integer
  end
end
