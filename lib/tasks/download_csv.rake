namespace :download_csv do
  coins = ["btc", "ltc", "nmc", "nvc", "ppc", "xrp"]
  exchange = {"btc" => "btce", "ltc" => "btce", "nmc" => "btce", "nvc" => "btce", "ppc" => "btce", "xrp" => "cryptsy"}.with_indifferent_access
  full_names = {"btc" => "Bitcoin", "ltc" => "Litecoin", "nmc" => "Namecoin", "nvc" => "Novacoin", "ppc" => "Peercoin", "xrp" => "Ripple"}.with_indifferent_access
  ref_coin = "usd"

  task get_files: :environment do

    coins.each do |coin|
      label_str = coin + "_" + ref_coin
      label_str = label_str.upcase if(coin == "xrp")
      csv_prices = Curl.post("http://alt19.com/", {source: exchange[coin], label: label_str, period: '1d', presence: 'csv', submit: 'OK'}).body_str
      file = File.join(Rails.root, 'tmp', 'csvFiles', label_str + ".csv")
      File.open(file, "w") do |file|
        csv_prices = ["DATE, TIME, LAST, r1, r2, r3\n", csv_prices].join if(coin == "xrp")
        file.puts csv_prices.gsub(label_str + ", ", "")
      end
    end

  end

  task place_in_database: :environment do

    coins.each do |coin|
      label_str = coin + "_" + ref_coin
      data =  SmarterCSV.process(Rails.root.join('tmp', 'csvFiles', label_str + '.csv').to_s)

      currency = Currency.create(name: coin, full_name: full_names[coin])
      data.each do |rate|
        extracted_date = Date.new(rate[:date].to_s[0..3].to_i, rate[:date].to_s[4..5].to_i, rate[:date].to_s[6..7].to_i)
        #keep only rates for weekdays
        if([0,6].include?(extracted_date.wday) == false)
          currency.exchange_rates << ExchangeRate.create(last: rate[:last], volume: rate[:volume], predicted: currency, date: extracted_date,
                                                        subject: coin, ref_cr: ref_coin)
        end
      end
    end

  end

end