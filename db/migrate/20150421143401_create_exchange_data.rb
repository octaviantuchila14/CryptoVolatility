class CreateExchangeData < ActiveRecord::Migration
  def change
    create_table :exchange_data do |t|
      t.date :date
      t.float :price
      t.name :reference_currency

      t.timestamps null: false
    end
  end
end
