class AddMarketIdToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :market_id, :integer
  end
end
