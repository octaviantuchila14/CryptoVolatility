class CreateNeuralNetworks < ActiveRecord::Migration
  def change
    create_table :neural_networks do |t|
      t.integer :epochs
      t.integer :hidden_layer_size
      t.integer :input_layer_size

      t.timestamps null: false
    end
  end
end
