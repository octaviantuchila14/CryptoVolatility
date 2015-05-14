class UpdateChiSquaredAndAverageDifferenceForPrediction < ActiveRecord::Migration
  def change
    rename_column :predictions, :average_difference, :last_ad
    rename_column :predictions, :chi_squared, :last_chisq
    add_column :predictions, :first_ad, :float
    add_column :predictions, :first_chisq, :float
  end
end
