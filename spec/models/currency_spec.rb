require 'rails_helper'

RSpec.describe Currency, type: :model do
  it "predicts the future evolution of the cryptocurrency" do
    expectedRates = []
    time = 1
    (1..10).each do |i|
      expectedRates << FactoryGirl.create(:exchange_rate, date: Date.today - i)
    end

    currency = FactoryGirl.create(:currency)
    market = FactoryGirl.create(:market)

    predicted_rates = currency.predict(expectedRates, market)
    expect(predicted_rates.size).to eq(1)
    expect(predicted_rates[:accuracy]).to be between(0, 1)
    expect(predicted_rates[:precision]).to be between(0, 1)
    expect(predicted_rates[:f1]).to be between(0, 1)
  end
end
