require 'rails_helper'

RSpec.describe Market, type: :model do
  it "computes expected return and variance of dataset" do
    market = FactoryGirl.create(:market)
    FactoryGirl.create(:exchange_rate, subject: "^GSPC", last: 0, date: Date.today)
    FactoryGirl.create(:exchange_rate, subject: "^GSPC", last: 5, date: Date.today + 1)
    FactoryGirl.create(:exchange_rate, subject: "^GSPC", last: 15, date: Date.today + 2)

    expect(ExchangeRate.all.length).to eq(3)
    expect(market.get_mean).to eq(7.5)
    expect(market.get_volatility).to eq(2.5)
    expect(market.get_variance).to eq(6.25)
    expect(market.get_covariance(arr = [5, 10])).to eq(12.5)
    expect(market.get_beta(arr = [5, 10])).to eq(2)
  end
end