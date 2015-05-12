class AddCurrencyIdToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :currency_id, :integer
  end
end
