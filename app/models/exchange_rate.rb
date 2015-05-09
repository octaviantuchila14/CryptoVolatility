class ExchangeRate < ActiveRecord::Base
  validates_presence_of :subject
  validates_presence_of :ref_cr
  validates_presence_of :last
  validates_presence_of :date
  validates_uniqueness_of :date, scope: :predicted
  belongs_to :currency

end
