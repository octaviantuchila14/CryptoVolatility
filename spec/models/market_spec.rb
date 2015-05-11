require 'rails_helper'

RSpec.describe Market, type: :model do

  before :each do
    @market = FactoryGirl.create(:market)
    @currency = FactoryGirl.create(:currency)
  end

  it "evaluates the beta of a currency" do
    3.times do |i|
      er = FactoryGirl.create(:exchange_rate, last: 10, date: Date.today - i)
      @market.exchange_rates << er
      @currency.exchange_rates << er
    end
    beta = @market.get_beta(@currency)
    expect(beta).to eq(1)
  end

  it "evaluates the beta of a currency" do
    val = [[0, 80, 90, 110],[0, 5, 25]]
    3.times do |i|
      erm = FactoryGirl.create(:exchange_rate, last: val[0][i], date: Date.today - 3 + i, subject: @market.name)
      ercr = FactoryGirl.create(:exchange_rate, last: val[1][i], date: Date.today - 3 + i, subject: @currency.name)
      @market.exchange_rates << erm
      @currency.exchange_rates << ercr
    end
    @market.exchange_rates << FactoryGirl.create(:exchange_rate, last: val[0][3], date: Date.today)

    beta = @market.get_beta(@currency)
    expect(beta).to eq(3)
  end

  #add another beta test
=begin
  it "evaluates the beta of a currency" do
    3.times do |i|
      er = FactoryGirl.create(:exchange_rate, last: 1*i)
      @market.exchange_rates << er
      @currency.exchange_rates << er
    end
    beta = market.get_beta(@currency)
    expect(beta).to eq(0)
  end
=end

  it "returns the evaluation of a currency" do
    3.times do |i|
      er = FactoryGirl.create(:exchange_rate, last: 10, date: Date.today - i)
      @market.exchange_rates << er
      @currency.exchange_rates << er
    end
    prediction = @market.capm_prediction(@currency)
    expect(prediction).to eq(0)
  end

end
