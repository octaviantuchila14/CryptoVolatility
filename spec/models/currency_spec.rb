require 'rails_helper'

RSpec.describe Currency, type: :model do
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
