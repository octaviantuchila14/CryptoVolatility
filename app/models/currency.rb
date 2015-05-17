require 'statsample'

class Currency < ActiveRecord::Base
  validates :name, presence: true
  validates :full_name, presence: true
  validates_uniqueness_of :name
  has_one :neural_network, as: :predictable
  has_one :prediction, as: :predictable
  has_many :exchange_rates
  belongs_to :market

  enum prediction_type: [:neural_network, :capm]

  self.after_initialize do
    #create a neural network corresponding to the currency
    if(self.neural_network == nil)
      create_neural_network
    end

    if(self.market == nil)
      if(Market.all.size == 0)
        create_market(name: :"^GSPC")
      else
        self.market = Market.first
      end
    end

  end

  def get_variation
    variations = []
    exchange_rates = self.exchange_rates.where(predicted: false).sort_by{|er| er.time}
    exchange_rates.each_index do |index|
      if(index + 1 < exchange_rates.size)
        variations << (exchange_rates[index + 1].last - exchange_rates[index].last)
      end
    end
    variations
  end

end
