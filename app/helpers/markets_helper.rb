module MarketsHelper

  def exchange_rates_as_hash(ers)
    ers_as_hash = {}
    ers.each do |er|
      ers_as_hash[er.date] = er.last
    end
    ers_as_hash
  end

end
