require 'rails_helper'

RSpec.describe Market, type: :model do

  before :each do
    @market = FactoryGirl.create(:market, market_expected_return: 10, risk_free_rate: 4)
    @currency = FactoryGirl.create(:currency)
  end

  it "evaluates the beta of a currency" do
    3.times do |i|
      er = FactoryGirl.create(:exchange_rate, last: 10, time: DateTime.now - i.days)
      @market.exchange_rates << er
      @currency.exchange_rates << er
    end
    beta = @market.get_beta(@currency)
    expect(beta).to eq(1)
  end

  it "evaluates the beta of a currency" do
    val = [[0, 80, 90, 110],[0, 5, 25]]
    3.times do |i|
      erm = FactoryGirl.create(:exchange_rate, last: val[0][i], time: DateTime.now - (3 - i).days, subject: @market.name)
      ercr = FactoryGirl.create(:exchange_rate, last: val[1][i], time: DateTime.now - (3 - i).days, subject: @currency.name)
      @market.exchange_rates << erm
      @currency.exchange_rates << ercr
    end
    @market.exchange_rates << FactoryGirl.create(:exchange_rate, last: val[0][3], time: DateTime.now)

    beta = @market.get_beta(@currency)
    expect(beta).to eq(3)
  end

  it "returns the CAPM price of currency" do
    val = [[0, 80, 90, 110],[0, 5, 25]]
    3.times do |i|
      erm = FactoryGirl.create(:exchange_rate, last: val[0][i], time: DateTime.now - (3 - i).days, subject: @market.name)
      ercr = FactoryGirl.create(:exchange_rate, last: val[1][i], time: DateTime.now - (3 - i).days, subject: @currency.name)
      @market.exchange_rates << erm
      @currency.exchange_rates << ercr
    end
    @market.exchange_rates << FactoryGirl.create(:exchange_rate, last: val[0][3], time: DateTime.now)

    capm = @market.capm_prediction(@currency)
    expect(capm).to eq(22)
  end

end
