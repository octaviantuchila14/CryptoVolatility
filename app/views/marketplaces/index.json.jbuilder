json.array!(@marketplaces) do |marketplace|
  json.extract! marketplace, :id
  json.url marketplace_url(marketplace, format: :json)
end
