class CreatePredictedRates < ActiveRecord::Migration
  def change
    create_table :predicted_rates do |t|
      t.date :date
      t.float :value
      t.string :subject
      t.string :ref_cr
      t.float :f1
      t.float :accuracy
      t.float :precision

      t.timestamps null: false
    end
  end
end
