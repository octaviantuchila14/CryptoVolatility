class ChangeExchangeRatesSubject < ActiveRecord::Migration
  def change
    rename_column :exchange_rates, :cr, :subject
  end
end
