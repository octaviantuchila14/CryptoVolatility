json.array!(@predictions) do |prediction|
  json.extract! prediction, :id, :last_ad
  json.url prediction_url(prediction, format: :json)
end
