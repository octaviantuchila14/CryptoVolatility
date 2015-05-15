class Prediction < ActiveRecord::Base
  has_many :exchange_rates
  belongs_to :neural_network
  belongs_to :predictable, polymorphic: true

  def past_estimates
    self.exchange_rates.where("time <= ? AND predicted = ? ", DateTime.now, true)
  end

  def future_estimates
    self.exchange_rates.where("time > ? AND predicted = ? ", DateTime.now, true)
  end

  #all exchange rates which are for a new data are added to the list of exchange rates
  def update_estimation(estimations)

    estimations.each do |er|
      per = self.exchange_rates.find_by(time: er.time.beginning_of_day..er.time.end_of_day)
      if(per != nil)
        #replace old one with new one
        self.exchange_rates.delete(per)
      else
        #if the exchange rate is new, then update the statistics
        actual_er = self.predictable.exchange_rates.find_by(time: er.time.beginning_of_day..er.time.end_of_day)
        if(actual_er != nil)
          update_stats(actual_er.last, er.last)
        end
      end
      self.exchange_rates << er
    end

  end

  def update_stats(obtained = 0.0, expected = 0.0)
    existing_size = past_estimates.count
    self.first_ad = (self.first_ad*existing_size + (expected - obtained).abs)/(existing_size + 1)
    self.first_chisq = Math.sqrt(self.first_chisq**2 + (expected - obtained)**2/expected)
  end
end