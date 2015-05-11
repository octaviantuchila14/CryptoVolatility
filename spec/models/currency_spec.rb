require 'rails_helper'

RSpec.describe Currency, type: :model do

  it "returns the differences in its daily prices" do
    cr = FactoryGirl.create(:currency)
    3.times do |i|
      er = FactoryGirl.create(:exchange_rate, last: i, date: Date.today - i)
      cr.exchange_rates << er
    end
    expect(cr.get_variation).to eq([-1, -1])
  end

  it "returns the differences in its daily prices" do
    cr = FactoryGirl.create(:currency)
    er1 = FactoryGirl.create(:exchange_rate, last: 0, date: Date.today - 3)
    er2 = FactoryGirl.create(:exchange_rate, last: 5, date: Date.today - 2)
    er3 = FactoryGirl.create(:exchange_rate, last: 20, date: Date.today - 1)
    cr.exchange_rates << er1
    cr.exchange_rates << er2
    cr.exchange_rates << er3

    expect(cr.get_variation).to eq([5, 15])
  end
=begin
  it "predicts the future evolution of the cryptocurrency" do
    expectedRates = []
    (0..9).each do |i|
      expectedRates << FactoryGirl.create(:exchange_rate, date: Date.today - i)
    end

    currency = FactoryGirl.create(:currency)
    market = FactoryGirl.create(:market)

    predicted_rates = currency.predict(1, market, 'usd')
    expect(predicted_rates.size).to eq(1)
    expect(predicted_rates[:accuracy]).to be between(0, 1)
    expect(predicted_rates[:precision]).to be between(0, 1)
    expect(predicted_rates[:f1]).to be between(0, 1)
  end
=end
end
