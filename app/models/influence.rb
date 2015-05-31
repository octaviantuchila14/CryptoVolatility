class Influence < ActiveRecord::Base
  belongs_to :knn
  belongs_to :article
end
