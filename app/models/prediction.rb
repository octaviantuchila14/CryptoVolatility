class Prediction < ActiveRecord::Base
  has_many :exchange_rates
  belongs_to :neural_network
  belongs_to :market
  belongs_to :currency
end
