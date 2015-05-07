class ChangeAverageDifferenceTypeInPredictions < ActiveRecord::Migration
  def change
    change_column :predictions, :average_difference, :float
  end
end
