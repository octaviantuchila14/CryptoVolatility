require 'rails_helper'

RSpec.describe Market, type: :model do

  before :each do
    @market = FactoryGirl.create(:market, name: '^GSPC', risk_free_rate: 0.25)
    @currency = FactoryGirl.create(:currency, full_name: 'Bitcoin', name: 'btc')

    3.times do |i|
      @currency.exchange_rates << FactoryGirl.create(:exchange_rate, date: Date.today - 3 + i, last: i + 1, predictable_id: @currency.id)
      @market.exchange_rates << FactoryGirl.create(:exchange_rate, date: Date.today - 3 + i, last: i + 1, predictable_id: @market.id)
    end
  end

  it 'for beta=1, it returns the same prices as for the market' do
    predicted_ex_rates = @market.capm_prediction(@currency)

    2.times do |i|
      expect(predicted_ex_rates[i].last).to eq(@currency.exchange_rates[i + 1].last)
      expect(predicted_ex_rates[i].date).to eq(@currency.exchange_rates[i + 1].date)
    end
  end


end
