json.array!(@neural_networks) do |neural_network|
  json.extract! neural_network, :id
  json.url neural_network_url(neural_network, format: :json)
end
