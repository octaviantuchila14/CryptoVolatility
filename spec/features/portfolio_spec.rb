require 'rails_helper'

describe 'My behaviour' do

  it 'should show portfolio option' do
    visit '/'
    expect(page).to have_content 'Create new portfolio'
  end

  # it 'should display an option for returns' do
  #
  #   portfolio = FactoryGirl.create(:portfolio)
  #   expect(portfolio.max_return > 0)
  # end

end