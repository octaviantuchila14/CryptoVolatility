class Portfolio < ActiveRecord::Base
  validate :valid_time_interval?
  validates :max_return, presence: true

  before_validation :compute_max_return, on: :create

  def valid_time_interval?
    start_date < end_date && end_date < Date.today
  end

  def compute_max_return
    biggest_return = 0

    currencies = Currency.all
    currencies.each do |cr|
      start_rate = ExchangeRate.where(date: self.start_date, predictable_id: cr.id).first
      end_rate = ExchangeRate.where(date: self.end_date, predictable_id: cr.id).first
      if(start_rate != nil && end_rate != nil && end_rate.last - start_rate.last > biggest_return)
        biggest_return = end_rate.last - start_rate.last
      end
    end

    self.max_return = biggest_return
  end

end
