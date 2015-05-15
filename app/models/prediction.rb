class Prediction < ActiveRecord::Base
  has_many :exchange_rates
  belongs_to :neural_network
  belongs_to :predictable, polymorphic: true

  after_initialize :set_estimations

  def set_estimations
    @first_estimation = []
    @last_estimation = []
  end

  def past_estimates
    self.exchange_rates.where("time <= ? AND predicted = ? ", DateTime.now, true)
  end

  def future_estimates
    self.exchange_rates.where("time > ? AND predicted = ? ", DateTime.now, true)
  end

  def update_estimation(estimations)
    date = date_valid

    p "first estimation is #{@first_estimation}"
    p "the day of the first element in the estimation #{estimations.first.time.day} and date #{date}"
    #remove estimations which are before today, at hour
    #keep removed items for statistics
    rem_f, rem_l = [], []
    @first_estimation.each do |fe|
      if(fe.time < date)
        @first_estimation.delete(fe)
        rem_f << fe
      end
    end
    @last_estimation.each do |le|
      if le.time < date
        @last_estimation.delete(le)
        rem_l << le
      end
    end

    estimations.each do |e|
      fe = @first_estimation.select{|fe|
        #p "the time is #{fe.time} and date #{date} and equality is #{fe.time == date}"
        fe.time == date}.first
      if(fe == nil)
        @first_estimation << e
      end
      le = @last_estimation.select{|le| le.time == date}.first
      if(le != nil)
        @last_estimation.delete(le)
      end
      @last_estimation << e
    end

    update_stats(rem_f, rem_l)

  end

  def date_valid
    date = Date.today
    if(Time.now.hour >= HOUR)
      date += 1.day
    end
    #the date returned does not have the current time
    date
  end

  def update_stats(rem_f, rem_l)

    existing_size = self.exchange_rates.where("time < ?", date_valid).count
    if(rem_f.size > 0)
      nr = 0
      sum_delta = 0.0
      chi_sq = 0.0
      rem_f.each do |pred|
        actual = self.predictable.exchange_rates.where(time: pred.time.beginning_of_day..pred.time.end_of_day).first
        sum_delta += (pred.last - actual.last)
        chi_sq += (pred.last - actual.last)*(pred.last - actual.last)/pred.last
        nr = nr + 1
      end
      self.first_ad = (self.first_ad*existing_size + sum_delta* nr)/(existing_size + nr)
      self.first_chisq = Math.sqrt(self.first_chisq**2 + chi_sq)
    end

    if(rem_l.size > 0)
      nr = 0
      sum_delta = 0.0
      chi_sq = 0.0
      rem_l.each do |pred|
        actual = self.predictable.exchange_rates.where(time: pred.time.beginning_of_day..pred.time.end_of_day).first
        sum_delta += (pred.last - actual.last)
        chi_sq += (pred.last - actual.last)*(pred.last - actual.last)/pred.last
        nr = nr + 1
      end
      self.last_ad = (self.last_ad*existing_size + sum_delta* nr)/(existing_size + nr)
      self.last_chisq = Math.sqrt(self.last_chisq**2 + chi_sq)
    end
  end

end