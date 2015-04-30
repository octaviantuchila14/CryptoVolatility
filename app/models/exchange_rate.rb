class ExchangeRate < ActiveRecord::Base
  validates :subject, presence: true
  validates :ref_cr, presence: true
  validates :last, presence: true
  validates :date, presence: true

end
