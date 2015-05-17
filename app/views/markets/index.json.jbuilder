json.array!(@markets) do |market|
  json.extract! market, :id
  json.url market_url(market, format: :json)
end
