require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do

  it "does not hold more than one exchange rate per day" do
    FactoryGirl.create(:exchange_rate, date: Date.today)
    expect{FactoryGirl.create(:exchange_rate, date: Date.today)}.to raise_error
    expect(ExchangeRate.all.size).to eq(1)
  end


end
