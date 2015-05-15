class ChangeDefaultStatsValuesToZeroForPrediction < ActiveRecord::Migration
  def change
    change_column :predictions, :last_ad, :float, default: 0.0
    change_column :predictions, :last_chisq, :float, default: 0.0
    change_column :predictions, :first_ad, :float, default: 0.0
    change_column :predictions, :first_chisq, :float, default: 0.0
  end
end