json.array!(@exchange_rates) do |exchange_rate|
  json.extract! exchange_rate, :id, :date, :time, :last, :high, :low, :volume
  json.url exchange_rate_url(exchange_rate, format: :json)
end
