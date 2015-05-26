class ExchangeRate < ActiveRecord::Base
  validates_presence_of :predictable
  validates_presence_of :ref_cr
  validates_presence_of :last
  validates_presence_of :date
  validates_uniqueness_of :date, scope: [:predicted, :predictable_id, :predictable_type]
  belongs_to :predictable, polymorphic: true

end
