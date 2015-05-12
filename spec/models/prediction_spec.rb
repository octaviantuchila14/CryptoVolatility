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

end
