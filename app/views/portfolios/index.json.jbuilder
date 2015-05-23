json.array!(@portfolios) do |portfolio|
  json.extract! portfolio, :id, :start_date, :end_date, :p_return, :variance
  json.url portfolio_url(portfolio, format: :json)
end
