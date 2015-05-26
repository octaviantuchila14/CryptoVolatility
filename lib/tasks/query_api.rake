namespace :query_api do

  Rails.env = "development"

  task get_currency_values: :environment do
    #TODO create structure of currencies & combine them

    #TODO create loop for all currency pairs

    client = CryptocoinchartsApi::Client.new
    pair = client.trading_pairs pairs: "btc_usd"

    exchange_rate = ExchangeRate.new
    exchange_rate.subject = 'btc'
    exchange_rate.ref_cr = 'usd'
    exchange_rate.time = DateTime.now

    p exchange_rate.date
    pair.each do |elem|
      exchange_rate.last = elem[:price]
      exchange_rate.volume = elem[:volume_first]
    end

    if ExchangeRate.where(time: exchange_rate.time, predicted: false, subject: exchange_rate.subject).blank?
      exchange_rate.save
    end

  end


  task get_market_data: :environment do

    datasp500 = YahooFinance.historical_quotes("^GSPC", { raw: :false, start_date: Date.today - 600, period: :daily})

    marketsp500 = Market.where(name: "^GSPC").first_or_create
    marketsp500.risk_free_rate = 0.0025
    save_data(datasp500, marketsp500)

    datasp100 = YahooFinance.historical_quotes("^OEX", { raw: :false, start_date: Date.today - 600, period: :daily})
    marketsp100 = Market.where(name: "^OEX").first_or_create
    marketsp100.risk_free_rate = 0.0025
    save_data(datasp100, marketsp100)

    marketsp500.submarket = marketsp100
  end

    def save_data(data, market)
      data.reverse_each do |daily_data|
        exchange_rate = ExchangeRate.new
        exchange_rate.predictable = market
        exchange_rate.ref_cr = 'usd'
        exchange_rate.last = daily_data[:close]
        exchange_rate.date = Date.new(daily_data[:trade_date][0..3].to_i, daily_data[:trade_date][5..6].to_i, daily_data[:trade_date][8..9].to_i)

        #check if I don't have rate already
        if ExchangeRate.where(date: exchange_rate.date, predicted: false, predictable: market).blank?
          exchange_rate.save
          market.exchange_rates << exchange_rate
        end

      end
  end

end
