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

  it 'should be classified as increasing when rates are increasing' do
    currency = FactoryGirl.create(:currency, name: 'btc', full_name: 'Bitcoin')
    FactoryGirl.create(:exchange_rate, predictable: currency, date: Date.today - 1.day, last: 1)
    FactoryGirl.create(:exchange_rate, predictable: currency, date: Date.today, last: 2)

    article = FactoryGirl.create(:article, published_at: DateTime.now - 1.day)
    visit "/articles/#{article.id}"
    expect(page).to have_content('The article could influence Bitcoin to increase')
  end

  it 'should not classify if the currency doesn\'t have exchange rates after' do
    currency = FactoryGirl.create(:currency, name: 'btc', full_name: 'Bitcoin')
    FactoryGirl.create(:exchange_rate, predictable: currency, date: Date.today - 2.days, last: 2)
    FactoryGirl.create(:exchange_rate, predictable: currency, date: Date.today, last: 1)

    article = FactoryGirl.create(:article, published_at: DateTime.now - 1.day)
    visit "/articles/#{article.id}"
    expect(page).to have_content('The article could influence Bitcoin to remain stable')
  end

  it 'classifies articles which don\'t have 2 exchange rates after them using knn' do

    currency = FactoryGirl.create(:currency, name: 'btc', full_name: 'Bitcoin')
    FactoryGirl.create(:exchange_rate, predictable: currency, date: Date.today - 2.days, last: 1)
    FactoryGirl.create(:exchange_rate, predictable: currency, date: Date.today - 1.days, last: 2)

    FactoryGirl.create(:article, published_at: DateTime.now - 3.day, summary: "mining, buy, paypal")
    article = FactoryGirl.create(:article, published_at: DateTime.now - 1.day, summary: "paypal worth")
    visit "/articles/#{article.id}"
    expect(page).to have_content('The article could influence Bitcoin to increase')

  end

end