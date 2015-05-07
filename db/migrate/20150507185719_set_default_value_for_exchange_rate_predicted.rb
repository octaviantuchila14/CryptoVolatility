class SetDefaultValueForExchangeRatePredicted < ActiveRecord::Migration
  def change
    change_column :exchange_rates, :predicted, :boolean, :default => false
  end
end
