require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do

  it "does not hold more than one exchange rate per day" do
    datetime = DateTime.now
    date = Date.today
    FactoryGirl.create(:exchange_rate, time: datetime, date: date)
    expect{FactoryGirl.create(:exchange_rate, time: datetime, date: date)}.to raise_error
    expect(ExchangeRate.all.size).to eq(1)
  end


end
