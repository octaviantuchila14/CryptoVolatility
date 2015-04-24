class ExchangeRate < ActiveRecord::Base
  validates :cr, presence: true
  validates :ref_cr, presence: true
end
