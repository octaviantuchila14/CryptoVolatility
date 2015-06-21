require 'statsample'

class Currency < ActiveRecord::Base
  validates :name, presence: true
  validates :full_name, presence: true
  validates_uniqueness_of :name
  has_one :neural_network, as: :predictable
  has_one :knn
  has_many :exchange_rates, as: :predictable
  belongs_to :marketplace

  has_many :currencies_portfolios
  has_many :portfolios, through: :currencies_portfolios

  enum prediction_type: [:neural_network, :capm]

  self.after_initialize do
    #create a neural network corresponding to the currency
    if(self.neural_network == nil)
      create_neural_network
    end

    if(self.knn == nil)
      create_knn
    end

    if(self.marketplace == nil)
      if(Marketplace.all.size == 0)
        create_marketplace
      else
        self.marketplace = Marketplace.first
      end
    end

  end

  def get_variation
    variations = []
    exchange_rates = self.exchange_rates.where(predicted: false).sort_by{|er| er.date}
    exchange_rates.each_index do |index|
      if(index + 1 < exchange_rates.size)
        variations << (exchange_rates[index + 1].last - exchange_rates[index].last)/exchange_rates[index].last
      end
    end
    variations
  end

  def return_between(start_date, end_date)
    er_start = self.exchange_rates.select{|er| start_date <= er.date && er.date <= end_date}.first
    er_end = self.exchange_rates.select{|er| er.date <= end_date}.last
    if(er_start == nil || er_end == nil || er_start.date >= er_end.date)
      return nil
    end
    p "for #{self.full_name}, the result is #{(er_end.last - er_start.last)/er_start.last}"
    (er_end.last - er_start.last)/er_start.last
  end

  def all_returns(start_date, end_date)
    returns = [0]
    ers = ExchangeRate.where(date: (start_date - 1.days)..(end_date + 1.days), predictable: self)
    ers.each_index do |i|
      if(i > 0)
        returns << (ers[i].last - ers[i - 1].last)/ers[i - 1].last
      end
    end
    returns
  end

  def get_variance(start_date, end_date)
    p "in the currency controller, the returns are #{all_returns(start_date, end_date)}"
    all_returns(start_date, end_date).to_scale.variance_population
  end

  def last_month
    variations = []
    exchange_rates = self.exchange_rates.where("date >= ? AND predicted = ?", Date.today - MONTH_DAYS.days, false).sort_by{|er| er.date}
    exchange_rates.each_index do |index|
      if(index + 1 < exchange_rates.size)
        variation = {}
        variation[:return] = (exchange_rates[index + 1].last - exchange_rates[index].last)/exchange_rates[index].last
        variation[:date] = exchange_rates[index + 1].date
        variations << variation
      end
    end
    variations
  end

  #returns exchange rates from the last 7 days
  def last_week_rates
    self.exchange_rates.sort_by {|er| er.date}.last(WEEK_DAYS)
  end

end
