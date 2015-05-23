require 'rails_helper'

describe 'My behaviour' do

  it 'should show portfolio option' do
    visit '/'
    expect(page).to have_content 'Create new portfolio'
  end

  it 'should display an option for returns, but the returns can\' be greater than the maximum return' do
    portfolio = FactoryGirl.create(:portfolio)
    visit "/portfolios/#{portfolio.id}"
    fill_in ''
    click_button 'Input return'
  end

  # it 'should display an option for returns' do
  #   portfolio = FactoryGirl.create(:portfolio)
  #   visit "/portfolios/#{portfolio.id}"
  #   click_button
  # end


end