class CreateExchangeRates < ActiveRecord::Migration
  def change
    create_table :exchange_rates do |t|
      t.date :date
      t.time :time
      t.float :last
      t.float :high
      t.float :low
      t.float :volume

      t.timestamps null: false
    end
  end
end
