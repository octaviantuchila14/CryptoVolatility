json.array!(@predictions) do |prediction|
  json.extract! prediction, :id, :average_difference
  json.url prediction_url(prediction, format: :json)
end
