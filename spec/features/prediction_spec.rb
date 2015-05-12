require 'rails_helper'

describe 'User navigates to the home page' do

  before :each do
    @currency = FactoryGirl.create(:currency, full_name: 'Bitcoin', name: 'btc')
    (0..100).each do |i|
      @currency.exchange_rates << FactoryGirl.create(:exchange_rate, subject: @currency.name, last: 10*i, time: DateTime.now - i.days)
    end
  end

  scenario 'she sees a prediction updated as time passes' do
    visit "/currencies/#{@currency.id}"
    select '5', :from => 'currency[prediction_days]'
    click_button 'Predict'
    expect(page).to have_content 'Expected values'

    future_size = @currency.prediction.future_estimates.size
    pred_first = @currency.prediction.future_estimates.first
    past_size = @currency.prediction.past_estimates.size

    #change date of the last estimation &
    #see if it is in the past estimates array
    pred_first.time -= 30*minutes

    #the currency's prediction was updated as soon as the new exchange rate was added
    expect(@currency.prediction.future_estimates.size).to eq(future_size - 1)
    expect(@currency.prediction.past_estimates.contains(pred_first)).to be true
    expect(@currency.prediction.past_estimates.size).to eq(past_size + 1)
  end
end