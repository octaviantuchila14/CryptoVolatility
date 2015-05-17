class AddMarketIdToCurrency < ActiveRecord::Migration
  def change
    add_column :currencies, :market_id, :integer
  end
end
