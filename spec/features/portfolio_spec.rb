require 'rails_helper'

describe 'My behaviour' do

  before :each do
    start_date = Date.new(2015, 1, 7)
    end_date = Date.new(2015, 1, 9)
    c1 = FactoryGirl.create(:currency)
    c2 = FactoryGirl.create(:currency, name: "ltc")
    (0..2).each do |i|
      c1.exchange_rates << FactoryGirl.create(:exchange_rate, date: start_date + i.days, last: i + 1, predictable: c1)
      c2.exchange_rates << FactoryGirl.create(:exchange_rate, date: start_date + i.days, last: i + 2, predictable: c2)
    end
    @portfolio = FactoryGirl.create(:portfolio, start_date: start_date, end_date: end_date)
  end

  it 'should show portfolio option' do
    visit '/'
    expect(page).to have_content 'Create new portfolio'
  end

  it 'should display an option for returns, but the returns can\' be greater than the maximum return' do
    visit "/portfolios/#{@portfolio.id}"
    fill_in 'return_number', with: '3'
    p "button will be clicked"
    expect{ click_button 'Obtain optimal portfolio' }.to raise_exception
  end

  # it 'should display an option for returns' do
  #   portfolio = FactoryGirl.create(:portfolio)
  #   visit "/portfolios/#{portfolio.id}"
  #   click_button
  # end


end