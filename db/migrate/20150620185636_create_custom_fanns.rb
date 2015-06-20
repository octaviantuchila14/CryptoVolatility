class CreateCustomFanns < ActiveRecord::Migration
  def change
    create_table :custom_fanns do |t|

      t.timestamps null: false
    end
  end
end
