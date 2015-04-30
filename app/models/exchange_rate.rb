class ExchangeRate < ActiveRecord::Base
  validates :subject, presence: true
  validates :ref_cr, presence: true

end
