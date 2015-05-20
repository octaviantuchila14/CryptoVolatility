class AddSupermarketIdToMarket < ActiveRecord::Migration
  def change
    add_column :markets, :supermarket_id, :integer
  end
end