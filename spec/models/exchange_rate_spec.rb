require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do

  it "does not hold more than one exchange rate per day" do
    datetime = DateTime.now
    FactoryGirl.create(:exchange_rate, time: datetime)
    expect{FactoryGirl.create(:exchange_rate, time: datetime)}.to raise_error
    expect(ExchangeRate.all.size).to eq(1)
  end


end
