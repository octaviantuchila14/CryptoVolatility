class Portfolio < ActiveRecord::Base
  validate :valid_time_interval?

  def valid_time_interval?
    start_date < end_date && end_date < Date.today
  end

  self.after_initialize do
    biggest_return = 0

    currencies = Currency.all
    currencies.each do |cr|
      start_date = ExchangeRate.where(date: start_date, predictable_id: cr.id).first
      end_date = ExchangeRate.where(date: end_date, predictable_id: cr.id).first
      p start_date
      p end_date
      if(start_date != nil && end_date != nil && end_date.last - start_date.last > biggest_return)
        biggest_return = end_date.last - start_date.last
      end
    end

    self.max_return = biggest_return
  end

end
