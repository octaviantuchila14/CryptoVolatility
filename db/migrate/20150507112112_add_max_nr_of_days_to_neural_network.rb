class AddMaxNrOfDaysToNeuralNetwork < ActiveRecord::Migration
  def change
    add_column :neural_networks, :max_nr_of_days, :integer
  end
end
