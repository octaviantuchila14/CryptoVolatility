require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do

  it "does not hold more than one exchange rate per day" do
    FactoryGirl.create(:exchange_rate, time: Time.now)
    expect{FactoryGirl.create(:exchange_rate, time: Time.now)}.to raise_error
    expect(ExchangeRate.all.size).to eq(1)
  end


end
