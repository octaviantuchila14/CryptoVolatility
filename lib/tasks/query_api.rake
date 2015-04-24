namespace :query_api do

  task get_currency_values: :environment do
    #TODO create structure of currencies & combine them

    p "querrying cryptocoincharts"
=begin
    client = CryptocoinchartsApi::Client.new
    pair = client.trading_pairs pairs: "btc_usd"

    exchange_rate = ExchangeRate.new
    exchange_rate.cr = 'btc'
    exchange_rate.ref_cr = 'usd'
    exchange_rate.date = Date.now
    exchange_rate.time = Time.now
    exchange_rate.value = pair[:value]
    exchange_rate.volume = pair[:volume]
    exchange_rate.save
=end
  end

end
