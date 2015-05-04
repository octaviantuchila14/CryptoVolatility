require 'rails_helper'

feature 'User navigates to the home page' do

  before :each do
    FactoryGirl.create(:currency, full_name: 'Bitcoin', name: 'btc')
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
    expect(page).to have_content "#{Date.today}"
  end

end
