class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.integer :average_difference

      t.timestamps null: false
    end
  end
end
