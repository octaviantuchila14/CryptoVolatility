class RemoveExpectedReturnFromMarket < ActiveRecord::Migration
  def change
    remove_column :markets, :market_expected_return, :float
  end
end
