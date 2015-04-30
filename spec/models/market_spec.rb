require 'rails_helper'

RSpec.describe Market, type: :model do
  it "computes expected return and variance of dataset" do
    market = Market.create(name: "^GSPC")
    ExchangeRate.create(subject: "^GSPC", last: 0, ref_cr: "usd", date: Date.today)
    ExchangeRate.create(subject: "^GSPC", last: 5, ref_cr: "usd", date: Date.today)
    ExchangeRate.create(subject: "^GSPC", last: 15, ref_cr: "usd", date: Date.today)

    expect(ExchangeRate.all.length).to eq(3)
    expect(market.get_mean).to eq(7.5)
    expect(market.get_volatility).to eq(2.5)
  end
end
