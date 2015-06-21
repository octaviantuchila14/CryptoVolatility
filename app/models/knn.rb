class Knn < ActiveRecord::Base

  belongs_to :currency
  has_many :influences

  def classify_article(summary, published_at)

    result = "remain stable"
    if(self.keywords == []) #not initialized yet
      get_keywords
    end

    occurences = []
    self.keywords.each do |kw|
      occurences << summary.scan(kw).length
    end

    if(self.currency.exchange_rates.where("date >= ?", published_at.to_date).count >= 2)
      ers = self.currency.exchange_rates.where("date >= ?", published_at.to_date).first(2).sort_by{|er| er.date}
      pp "We have the exhcange rates: #{ers[0].last} from #{ers[0].date}, #{ers[1].last} from #{ers[1].date}"
      result = ers[0].last < ers[1].last ? "increase" : "decrease"
    else
      pp "using classifier"
      result = classify(occurences)
    end

    if(result != "remain stable")
      self.cdata[occurences] = result
      self.cdata_will_change!
      self.save
    end

    influence = Influence.new(classification: result)
    self.influences << influence
    influence
  end


  private


  def classify(occurences)
    distances = {}
    self.cdata.each do |key, result|
      distances[euclidean(key.split(", ").map(&:to_i), occurences)] = result
    end

    distances = distances.sort.to_h

    if(distances.empty?)
      return "remain stable"
    end

    increase, decrease = 0, 0
    (0..KNN_NEIGHBORS - 1).each do |i|
      distances.values[i] == "decrease" ? decrease = decrease + 1 : increase = increase + 1
    end
    decrease > increase ? "decrease" : "increase"
  end


  def euclidean(a1, a2)
    Math.sqrt(a1.zip(a2).map { |x| (x[1] - x[0])**2 }.reduce(:+))
  end


  def get_keywords
    self.keywords = ["mining", "price", "value", "miner", "buy", "exchange", "wallet", "calculator", "usd",
                 "rate", "chart", "free", "news", "paypal", "wiki", "basic", "hardware", "mtgox", "pool",
                 "reddit", "euro", "market", "silk road", "stock", "coinbase", "worth", "blockchain",
                 "address", "difficulty", "forum", "ebay", "mt gox", "trading"]

    self.keywords_will_change!
    self.save!
  end

end
