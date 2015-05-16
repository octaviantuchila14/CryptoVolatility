require 'rails_helper'

RSpec.describe Prediction, type: :model do

  it "returns past and future predictions separately" do
    prediction = FactoryGirl.create(:prediction)
    past_er, future_er = [], []
    5.times do |i|
      past_er << FactoryGirl.create(:exchange_rate, time: DateTime.now - (5 - (i + 1)).days, date: Date.today- (5 - (i + 1)).days, predicted: true)
      future_er << FactoryGirl.create(:exchange_rate, time: DateTime.now + (i + 1).days, date: Date.today + (i + 1).days, predicted: true)
    end
    prediction.exchange_rates << past_er
    prediction.exchange_rates << future_er
    expect(prediction.past_estimates).to eq(past_er)
    expect(prediction.future_estimates).to eq(future_er)
  end

  it "computes the average difference and chi squared for its predicted exchange rates" do
    prediction = FactoryGirl.create(:prediction)
    currency = FactoryGirl.create(:currency)
    prediction.predictable = currency

    #create 3 estimations and expect the values returned to be for the first and the last
    real, pred1, pred2, pred3 = [], [], [], []
    (1..5).each do |i|
      real << FactoryGirl.create(:exchange_rate, time: DateTime.now - (5 - (i + 1)).days, last: i, date: Date.today - (5 - (i + 1)).days)
      pred1 << FactoryGirl.build(:exchange_rate, time: DateTime.now - (5 - (i + 1)).days, last: i+1, predicted: true, date: Date.today - (5 - (i + 1)).days)
      pred2 << FactoryGirl.build(:exchange_rate, time: DateTime.now - (5 - (i + 1)).days, last: i+2, predicted: true, date: Date.today - (5 - (i + 1)).days)
      pred3 << FactoryGirl.build(:exchange_rate, time: DateTime.now - (5 - (i + 1)).days, last: i+3, predicted: true, date: Date.today - (5 - (i + 1)).days)
    end
    currency.exchange_rates = real
    prediction.update_estimation(pred1)
    prediction.update_estimation(pred2)

    pred1.each_index do |i|
      expect(prediction.exchange_rates.include?(pred1[i])).to be(false)
      expect(prediction.exchange_rates.include?(pred2[i])).to be(true)
    end

    expect(prediction.first_ad).to be_between(1 - ACC_ERROR, 1 + ACC_ERROR)
    expect(prediction.first_chisq).to be_between(1.204159 - ACC_ERROR, 1.204159 + ACC_ERROR)

    #should have no effect on values
    prediction.update_estimation(pred3)

    pred2.each_index do |i|
      expect(prediction.exchange_rates.include?(pred2[i])).to be(false)
      expect(prediction.exchange_rates.include?(pred3[i])).to be(true)
    end

    expect(prediction.first_ad).to be_between(1 - ACC_ERROR, 1 + ACC_ERROR)
    expect(prediction.first_chisq).to be_between(1.204159 - ACC_ERROR, 1.204159 + ACC_ERROR)

  end


  it "has correct formulas for average and chi_squared" do

    prediction = FactoryGirl.create(:prediction)

    prediction.update_stats(1.0, 3.0)
    expect(prediction.first_ad).to be_between(2 - ACC_ERROR, 2 + ACC_ERROR)
    expect(prediction.first_chisq).to be_between(1.1547 - ACC_ERROR, 1.1547 + ACC_ERROR)
  end

end
