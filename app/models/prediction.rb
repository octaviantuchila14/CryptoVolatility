class Prediction < ActiveRecord::Base
  has_many :exchange_rates
  belongs_to :neural_network
  belongs_to :market
  belongs_to :currency

  def past_estimates
    self.exchange_rates.where("time <= ? AND predicted = ? ", DateTime.now, true)
  end

  def future_estimates
    self.exchange_rates.where("time > ? AND predicted = ? ", DateTime.now, true)
  end

end