class AddChiSquaredToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :chi_squared, :float
  end
end
