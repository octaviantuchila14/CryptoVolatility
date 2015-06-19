class CreateMarketplaces < ActiveRecord::Migration
  def change
    create_table :marketplaces do |t|

      t.timestamps null: false
    end
  end
end
