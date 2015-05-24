class CurrenciesPortfolio < ActiveRecord::Base
  belongs_to :currency
  belongs_to :portfolio
end
