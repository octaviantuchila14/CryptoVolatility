class AddMarketplaceIdToCurrency < ActiveRecord::Migration
  def change
    add_column :currencies, :marketplace_id, :integer
  end
end
