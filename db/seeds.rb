# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

currency = Currency.create(name: "btc", full_name: "Bitcoin")
100.times do |i|
  currency.exchange_rates << ExchangeRate.create(subject: currency.name, date: Date.today - i, last: 100 - i, ref_cr: "usd")
end
