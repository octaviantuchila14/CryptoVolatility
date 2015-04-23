class Currency < ActiveRecord::Base
  validates :name, presence: true
end
