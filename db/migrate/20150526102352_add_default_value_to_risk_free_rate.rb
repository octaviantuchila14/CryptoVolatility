class AddDefaultValueToRiskFreeRate < ActiveRecord::Migration
  def change
    change_column :markets, :risk_free_rate, :float, default: 0.0025
  end
end
