require 'rails_helper'

describe 'Every article' do

  it 'should be classified' do
    currency = FactoryGirl.create(:currency, name: 'btc', full_name: 'Bitcoin')
    FactoryGirl.create(:exchange_rate, predictable: currency, date: Date.today)
    FactoryGirl.create(:exchange_rate, predictable: currency, date: Date.today - 1.day)

    article = FactoryGirl.create(:article)
    visit "/articles/#{article.id}"
    expect(page).to have_content('The article could influence Bitcoin to')
  end

end