require 'rails_helper'

feature 'User navigates to the home page' do

  before :each do
    @cr = FactoryGirl.create(:currency, full_name: 'Bitcoin', name: 'btc')
    @cr.create_neural_network
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
    expect(page).to have_selector('select_days')
  end

end
