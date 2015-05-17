require 'rails_helper'

describe 'My behaviour' do

  before :each do
    @market = FactoryGirl.create(:market, name: '^GSPC', risk_free_rate: 0.25)
    @currency = FactoryGirl.create(:currency, full_name: 'Bitcoin', name: 'btc')

    3.times do |i|
      @currency.exchange_rates << FactoryGirl.create(:exchange_rate, date: Date.today - 3 + i, last: i + 1, predictable_id: @currency.id)
      @market.exchange_rates << FactoryGirl.create(:exchange_rate, date: Date.today - 3 + i, last: 10*(i + 1), predictable_id: @market.id)
    end
  end

  it 'should display CAPM estimation' do
    visit "/currencies/#{@currency.id}"
    click_button 'Apply financial models'
    expect(page).to have_content('CAPM estimation')
  end

end