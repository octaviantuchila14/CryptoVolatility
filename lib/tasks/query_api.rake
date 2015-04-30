namespace :query_api do

  Rails.env = "development"

  task get_currency_values: :environment do
    #TODO create structure of currencies & combine them

    #TODO create loop for all currency pairs

    p "querrying cryptocoincharts"

    client = CryptocoinchartsApi::Client.new
    pair = client.trading_pairs pairs: "btc_usd"

    exchange_rate = ExchangeRate.new
    exchange_rate.subject = 'btc'
    exchange_rate.ref_cr = 'usd'
    exchange_rate.date = Date.new
    exchange_rate.time = Time.new

    pair.each do |elem|
      exchange_rate.last = elem[:price]
      exchange_rate.volume = elem[:volume_first]
    end

    exchange_rate.save
  end


  task get_market_data: :environment do

    p "getting market data from Yahoo"
    data = YahooFinance.historical_quotes("^GSPC", { raw: :false, start_date: Date.today - 365, period: :daily})

    Market.create(name: "^GSPC")
    data.foreach do |daily_data|
      exchange_rate = ExchangeRate.new
      exchange_rate.subject = "^GSPC"
      exchange_rate.ref_cr = 'usd'
      exchange_rate.date = daily_data[:start_date]
      exchange_rate.last = daily_data[:close]
      exchange_rate.save
    end
  end

end
