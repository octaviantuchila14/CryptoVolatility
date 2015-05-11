require 'rails_helper'

RSpec.describe Market, type: :model do

  before :all do
    @market = FactoryGirl.create(:market)
    @currency = FactoryGirl.create(:currency)
  end

  it "evaluates the beta of a currency" do
    3.times do
      er = FactoryGirl.create(:exchange_rate, last: 10)
      @market.exchange_rates << er
      @currency.exchange_rates << er
    end
    beta = market.get_beta(@currency)
    expect(beta).to eq(1)
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
    3.times do
      er = FactoryGirl.create(:exchange_rate, last: 10)
      @market.exchange_rates << er
      @currency.exchange_rates << er
    end
    prediction = market.capm_prediction(@currency)
    expect(prediction).to eq(0)
  end

end
