require 'rails_helper'

describe 'My behaviour' do

  before :each do
    @marketplace = FactoryGirl.create(:marketplace)
    @currency = FactoryGirl.create(:currency, full_name: 'Bitcoin', name: 'btc')

    3.times do |i|
      @currency.exchange_rates << FactoryGirl.create(:exchange_rate, date: Date.today - 3 + i, last: i + 1, predictable_id: @currency.id)
    end

    visit "/currencies/#{@currency.id}"
    click_button 'Financial Advice'

  end

  it 'should show other cryptocurrencies with a low correlation' do
    expect(page).to have_content('Cryptocurrencies with low correlations')
  end

end