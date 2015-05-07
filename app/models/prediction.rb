class Prediction < ActiveRecord::Base
  has_many :exchange_rates
  belongs_to :neural_network
end
