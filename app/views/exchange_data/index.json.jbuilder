json.array!(@exchange_data) do |exchange_datum|
  json.extract! exchange_datum, :id, :date, :price, :reference_currency
  json.url exchange_datum_url(exchange_datum, format: :json)
end
