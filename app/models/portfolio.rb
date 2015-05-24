class Portfolio < ActiveRecord::Base

  validate :valid_time_interval?
  validate :return_between_zero_and_max_return?, on: :update
  validates :max_return, presence: true
  before_validation :compute_max_return, on: :create

  has_and_belongs_to_many :currencies

  def valid_time_interval?
    unless(start_date < end_date && end_date <= Date.today)
      errors.add(:end_date, "start and end date don't form a valid interval")
    end
  end

  def return_between_zero_and_max_return?
    unless(0 <= p_return && p_return <= max_return)
      errors.add(:p_return, "The return is not between 0 and the max return")
    end
  end

  def compute_max_return
    biggest_return = 0

    currencies = Currency.all
    currencies.each do |cr|
      cr_return = cr.return_between(self.start_date, self.end_date)
      if(cr_return != nil && cr_return > biggest_return)
        biggest_return = cr_return
      end
    end

    self.max_return = biggest_return
  end

  def compute_weights
    individual_returns = []

    Currency.all.each do |cr|
      ri = cr.return_between(self.start_date, self.end_date)
      if(ri != nil)
        individual_returns << ri
        self.currencies << cr
      end
    end

  end

end
