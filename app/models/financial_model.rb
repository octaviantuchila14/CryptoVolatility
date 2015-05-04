class FinancialModel < ActiveRecord::Base

  def capm(beta, market_rate, risk_free_rate = 0)
    risk_free_rate + beta * (market_rate - risk_free_rate)
  end

end
