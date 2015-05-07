require 'rails_helper'

feature 'User navigates to the home page' do

  before :each do
    @currency = FactoryGirl.create(:currency, full_name: 'Bitcoin', name: 'btc')
    @currency.create_neural_network
  end

  scenario 'she sees a list of cryptocurrencies' do
    FactoryGirl.create(:currency, full_name: 'Litecoin', name: 'ltc')
    visit '/'
    expect(page).to have_content 'Bitcoin'
    expect(page).to have_content 'Litecoin'
  end

  scenario 'she sees a list of cryptocurrencies' do
    visit '/'
    click_link 'Show'
    expect(page).to have_content 'btc'
  end

  scenario 'she sees a drop down and can select a number of days between 1 and 30' do
    visit '/'
    click_link 'Show'
    expect(page).to have_xpath('//div[@id=\'select_days\']')
  end

  scenario 'she can view a prediction for that number of days' do
    @currency.create_neural_network
    (0..100).each do |i|
      FactoryGirl.create(:exchange_rate, subject: @currency.name, last: 10*i, date: Date.today - i)
    end

    visit '/'
    click_link 'Show'
    #select number of days
    select '5', :from => 'currency[prediction_days]'
    click_button 'Predict'
    expect(page).to have_content 'Expected values'
  end

end
