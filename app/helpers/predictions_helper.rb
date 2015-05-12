module PredictionsHelper

  def estimates_as_hash(ers)
    ers_as_hash = {}
    ers.each do |er|
      ers_as_hash[er.time] = er.last
    end
    ers_as_hash
  end

end
