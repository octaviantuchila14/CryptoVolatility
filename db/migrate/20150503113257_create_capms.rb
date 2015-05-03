class CreateCapms < ActiveRecord::Migration
  def change
    create_table :capms do |t|

      t.timestamps null: false
    end
  end
end
