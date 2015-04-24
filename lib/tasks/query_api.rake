namespace :query_api do

  task get_currency_values: :environment do
    #TODO create structure of currencies & combine them

    p "querrying cryptocoincharts"

    client = CryptocoinchartsApi::Client.new
    pair = client.trading_pairs pairs: "btc_usd"

    exchange_rate = ExchangeRate.new
    exchange_rate.cr = 'btc'
    exchange_rate.ref_cr = 'usd'
    exchange_rate.date = Date.new
    exchange_rate.time = Time.new

    pair.each do |elem|
      exchange_rate.last = elem[:price]
      exchange_rate.volume = elem[:volume_first]
    end

    exchange_rate.save

  end

end
