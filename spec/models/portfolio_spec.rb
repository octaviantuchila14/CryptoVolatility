require 'rails_helper'

RSpec.describe Portfolio, type: :model do

  before :each do
    @start_date = Date.new(2015, 1, 7)
    @end_date = Date.new(2015, 1, 9)
    @portfolio = FactoryGirl.create(:portfolio, start_date: @start_date, end_date: @end_date)
    @c1 = FactoryGirl.create(:currency)
    @c2 = FactoryGirl.create(:currency, name: "ltc")
    (0..2).each do |i|
      @c1.exchange_rates << FactoryGirl.create(:exchange_rate, date: @start_date + i.days, last: i + 1, predictable: @c1)
      @c2.exchange_rates << FactoryGirl.create(:exchange_rate, date: @start_date + i.days, last: i + 2, predictable: @c2)
    end
  end

  it 'returns the maximum exchange rate among currencies' do
    expect(@portfolio.compute_max_return).to eq(2.0)
  end

  it 'minimizes the portfolio selection - simple example' do
    @portfolio.p_return = 2.0
    weights = @portfolio.compute_weights
    expect(weights[@c1]).to eq(1)
    expect(weights[@c1]).to eq(0)
  end

end