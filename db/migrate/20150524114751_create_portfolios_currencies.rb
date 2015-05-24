class CreatePortfoliosCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies_portfolios do |t|
      t.belongs_to :portfolios, index: true
      t.belongs_to :currencies, index: true
    end
  end
end
