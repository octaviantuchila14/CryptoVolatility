require 'rails_helper'

RSpec.describe Currency, type: :model do

  it "returns the differences in its daily prices" do
    cr = FactoryGirl.create(:currency)
    3.times do |i|
      er = FactoryGirl.create(:exchange_rate, last: i, time: DateTime.now - i.days, date: Date.today - i.days)
      cr.exchange_rates << er
    end
    expect(cr.get_variation).to eq([-1, -1])
  end

  it "returns the differences in its daily prices" do
    cr = FactoryGirl.create(:currency)
    er1 = FactoryGirl.create(:exchange_rate, last: 0, time: DateTime.now - 3.days, date: Date.today - 3.days)
    er2 = FactoryGirl.create(:exchange_rate, last: 5, time: DateTime.now - 2.days, date: Date.today - 2.days)
    er3 = FactoryGirl.create(:exchange_rate, last: 20, time: DateTime.now - 1.days, date: Date.today - 1.days)
    cr.exchange_rates << er1
    cr.exchange_rates << er2
    cr.exchange_rates << er3

    expect(cr.get_variation).to eq([5, 15])
  end

  it "returns the differences between two days" do
    cr = FactoryGirl.create(:currency)
    (0..2).each do |i|
      er = FactoryGirl.create(:exchange_rate, last: i + 1, date: Date.today - i.days)
      cr.exchange_rates << er
    end
    expect(cr.return_between(cr.exchange_rates.first.date, cr.exchange_rates.last.date)).to eq(2)
  end

  it "returns all the daily returns" do
    cr = FactoryGirl.create(:currency)
    (0..2).each do |i|
      er = FactoryGirl.create(:exchange_rate, last: i + 1, date: Date.today - i.days)
      cr.exchange_rates << er
    end
    a_ret = cr.all_returns(cr.exchange_rates.first.date, cr.exchange_rates.last.date)
    expect(a_ret[0]).to eq(1.0)
    expect(a_ret[1]).to eq(0.5)
  end

end
