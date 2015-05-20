# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

market = Market.create(name: "^GSPC", risk_free_rate: 0.25)
currency = Currency.create(name: "btc", full_name: "Bitcoin")

liquid_market = Market.create(name: '^OEX', risk_free_rate: 0.25)
market.submarket = liquid_market

100.times do |i|
  market.exchange_rates << ExchangeRate.create(subject: currency.name, date: Date.today - (100 - i).days, last: i + 1, ref_cr: "usd")
  liquid_market.exchange_rates << ExchangeRate.create(subject: currency.name, date: Date.today - (100 - i).days, last: i + 1, ref_cr: "usd")
  currency.exchange_rates << ExchangeRate.create(subject: currency.name, date: Date.today - (100 -  i).days, last: (i + 1), ref_cr: "usd")
end