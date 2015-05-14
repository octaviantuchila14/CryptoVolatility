require 'rails_helper'

RSpec.describe Prediction, type: :model do

  it "returns past and future predictions separately" do
    prediction = FactoryGirl.create(:prediction)
    past_er, future_er = [], []
    5.times do |i|
      past_er << FactoryGirl.create(:exchange_rate, time: DateTime.now - (5 - (i + 1)).days, predicted: true)
      future_er << FactoryGirl.create(:exchange_rate, time: DateTime.now + (i + 1).days, predicted: true)
    end
    prediction.exchange_rates << past_er
    prediction.exchange_rates << future_er
    expect(prediction.past_estimates).to eq(past_er)
    expect(prediction.future_estimates).to eq(future_er)
  end

  it "computes the average difference and chi squared for its predicted exchange rates" do
    prediction = FactoryGirl.create(:prediction)
    currency = FactoryGirl.create(:currency)

    #create 3 estimations and expect the values returned to be for the first and the last
    real, pred1, pred2, pred3 = [], [], [], []
    (1..5).each do |i|
      real << FactoryGirl.create(:exchange_rate, time: DateTime.now - (5 - (i + 1)).days, last: i)
      pred1 << FactoryGirl.create(:exchange_rate, time: DateTime.now - (5 - (i + 1)).days, last: i+1, predicted: true)
      pred2 << FactoryGirl.create(:exchange_rate, time: DateTime.now - (5 - (i + 1)).days, last: i+2, predicted: true)
      pred3 << FactoryGirl.create(:exchange_rate, time: DateTime.now - (5 - (i + 1)).days, last: i+3, predicted: true)
    end
    currency.exchange_rates = real
    prediction.update_estimation(pred1)
    prediction.update_estimation(pred2)
    prediction.update_estimation(pred3)

    expect(prediction.first_ad).to eq(1)
    expect(prediction.first_chisq).to eq(1.51107)
    expect(prediction.last_ad).to eq(3)
    expect(prediction.last_chisq).to eq(4.53321)
  end

end
