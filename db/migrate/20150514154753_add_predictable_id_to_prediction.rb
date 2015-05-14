class AddPredictableIdToPrediction < ActiveRecord::Migration
  def change
    remove_column :predictions, :currency_id
    remove_column :predictions, :market_id
    add_column :predictions, :predictable_id, :integer
    add_column :predictions, :predictable_type, :string
  end
end
