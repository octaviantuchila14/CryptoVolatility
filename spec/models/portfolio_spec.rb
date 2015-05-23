require 'rails_helper'

RSpec.describe Portfolio, type: :model do

  it 'returns the maximum exchange rate among currencies' do
    start_date = Date.new(2015, 1, 7)
    end_date = Date.new(2015, 1, 9)
    c1 = FactoryGirl.create(:currency)
    c2 = FactoryGirl.create(:currency, name: "ltc")
    (0..2).each do |i|
      c1.exchange_rates << FactoryGirl.create(:exchange_rate, date: start_date + i.days, last: i + 1)
      c2.exchange_rates << FactoryGirl.create(:exchange_rate, date: start_date + i.days, last: i + 2)
    end
    portfolio = FactoryGirl.create(:portfolio, start_date: start_date, end_date: end_date)
    expect(portfolio.max_return).to eq(2.0)
  end

end