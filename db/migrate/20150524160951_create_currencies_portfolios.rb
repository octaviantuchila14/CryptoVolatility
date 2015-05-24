class CreateCurrenciesPortfolios < ActiveRecord::Migration
  def change
    create_table :currencies_portfolios do |t|
      t.integer :currency_id
      t.integer :portfolio_id

      t.timestamps null: false
    end
  end
end
