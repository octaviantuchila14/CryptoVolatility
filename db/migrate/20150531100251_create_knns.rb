class CreateKnns < ActiveRecord::Migration
  def change
    create_table :knns do |t|
      t.integer :currency_id
      t.string :keywords, array: true, default: []
      t.hstore :cdata

      t.timestamps null: false
    end
  end
end
