require 'rails_helper'

describe 'My behaviour' do

  before :each do
    start_date = Date.new(2015, 1, 7)
    end_date = Date.new(2015, 1, 9)
    c1 = FactoryGirl.create(:currency, name: "btc", full_name: "Bitcoin")
    c2 = FactoryGirl.create(:currency, name: "ltc", full_name: "Litecoin")
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
    click_button 'Obtain optimal portfolio'
    expect(page).to have_content("The return is not between 0 and the max return")
  end

  it 'should display an option for returns' do
    visit "/portfolios/#{@portfolio.id}"
    click_button 'Obtain optimal portfolio'
    expect(page).to have_content("Variance")
    expect(page).to have_content("Our portfolio will have the following currencies with their respective weights")
  end

  it 'should compute the weights for a set of currencies' do
    visit "/portfolios/#{@portfolio.id}"
    click_button 'Obtain optimal portfolio'
    expect(page.all('table#wt tr').count).to eq(2 + 1)

    nm = page.all('table#wt td.full_name').map(&:text)
    expect(nm).to include("Bitcoin", "Litecoin")
    weights = page.all('table#wt td.weight').map(&:text)
    expect(weights).to include("100%", "0%")
  end

end