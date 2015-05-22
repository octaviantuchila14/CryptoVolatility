namespace :download_csv do
  require 'mechanize'

  task get_files: :environment do
    coins = ["btc", "ltc", "nmc", "ppc", "nvc"]
    ref_coin = "usd"

    coins.each do |coin|
      label_str = coin + "_" + ref_coin
      csv_prices = Curl.post("http://alt19.com/", {source: 'btce', label: label_str, period: '1d', presence: 'csv', submit: 'OK'})
      file = File.join(Rails.root, 'tmp', 'csvFiles', label_str + ".csv")
      File.open(file, "w") do |file|
        file.puts csv_prices.body_str
      end
    end

  end
end