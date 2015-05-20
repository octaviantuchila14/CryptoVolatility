require 'rails_helper'

describe 'My behaviour' do

  before :each do
    @market = FactoryGirl.create(:market, name: '^GSPC', risk_free_rate: 0.25)
    @currency = FactoryGirl.create(:currency, full_name: 'Bitcoin', name: 'btc')
    @liquid_market = FactoryGirl.create(:market, name: '^OEX')
    @market.submarket = @liquid_market

    3.times do |i|
      @currency.exchange_rates << FactoryGirl.create(:exchange_rate, date: Date.today - 3 + i, last: i + 1, predictable_id: @currency.id)
      @market.exchange_rates << FactoryGirl.create(:exchange_rate, date: Date.today - 3 + i, last: 10*(i + 1), predictable_id: @market.id)
      @liquid_market.exchange_rates << FactoryGirl.create(:exchange_rate, date: Date.today - 3 + i, last: 10*(i + 1), predictable_id: @market.id)
    end

    visit "/currencies/#{@currency.id}"
    click_button 'Apply financial models'

  end

  it 'should display CAPM estimation' do
    expect(page).to have_content('CAPM estimation')
  end

  it 'should display illiquidity adjusted estimation' do
    expect(page).to have_content('Illiquidity adjusted estimation')
  end

end