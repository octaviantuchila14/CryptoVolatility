class Portfolio < ActiveRecord::Base
  validate :valid_time_interval?
  validate :return_between_zero_and_max_return?, on: :update
  validates :max_return, presence: true

  before_validation :compute_max_return, on: :create

  def valid_time_interval?
    unless(start_date < end_date && end_date <= Date.today)
      errors.add(:end_date, "start and end date don't form a valid interval")
    end
  end

  def return_between_zero_and_max_return?
    unless(0 <= p_return && p_return <= max_return)
      p "add return errors"
      errors.add(:p_return, "The return is not between 0 and the max return")
    end
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
