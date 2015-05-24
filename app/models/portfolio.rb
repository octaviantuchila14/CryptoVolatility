class Portfolio < ActiveRecord::Base

  validate :valid_time_interval?
  validate :return_between_zero_and_max_return?, on: :update
  validates :max_return, presence: true
  before_validation :compute_max_return, on: :create

  has_many :currencies_portfolios
  has_many :currencies, through: :currencies_portfolios

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
    overall_returns = []
    all_returns = []

    Currency.all.each do |cr|
      ri = cr.return_between(self.start_date, self.end_date)
      if(ri != nil)
        overall_returns << ri
        self.currencies << cr
        all_returns << cr.all_returns(self.start_date, self.end_date)
      end
    end

    m = Matrix.build(self.currencies.size + 2, self.currencies.size + 2)
    #do linear computation
    (0..self.currencies.size - 1).each do |i|
      (0..self.currencies.size - 1).each do |j|
        if(i == j)
          m[i, j] = 1.0
        else
          m[i, j] = Statsample::Bivariate.covariance(all_returns[i].to_scale, all_returns[j].to_scale)
        end
      end
    end
    (0..self.currencies.size - 1).each do |k|
      m[self.currencies.size, k] = -overall_returns[k]
      m[self.currencies.size + 1, k] = -1.0
      m[k, self.currencies.size] = -overall_returns[k]
      m[k, self.currencies.size + 1] = -1.0
    end

    v = Matrix.build(self.currencies.size + 2, 1)
    v[self.currencies.size, 0] = -self.p_return
    v[self.currencies.size + 1, 0] = -1.0

    weights_vector = m.inverse * v

    weights = {}
    (0..self.currencies.size - 1).each do |i|
      weights[self.currencies[i]] = weights_vector[i, 0]
    end

    weights
  end

end
