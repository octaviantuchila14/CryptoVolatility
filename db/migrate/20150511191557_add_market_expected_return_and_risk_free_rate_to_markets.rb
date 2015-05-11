class AddMarketExpectedReturnAndRiskFreeRateToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :market_expected_return, :float
    add_column :markets, :risk_free_rate, :float
  end
end
