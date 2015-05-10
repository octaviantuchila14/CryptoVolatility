class AddPredictionTypeToCurrency < ActiveRecord::Migration
  def change
    add_column :currencies, :prediction_type, :integer
  end
end
