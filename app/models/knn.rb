class Knn < ActiveRecord::Base

  belongs_to :currency

  def classify_article(summary, published_at)

    result = "stable"
    if(:keywords == []) #not initialized yet
      get_keywords
    end

    if(published_at.to_date < self.currency.exchange_rates.maximum(:date))
      ers = self.currency.exchange_rates.where("date >= ?", published_at.to_date).first(2)
      result = ers[0].last < ers[1].last ? "increase" : "decrease"
    end

    result
  end


  private

  def get_keywords
    self.keywords = ["mining", "price", "value", "miner", "buy", "exchange", "wallet", "calculator", "usd",
                 "rate", "chart", "free", "news", "paypal", "wiki", "basic", "hardware", "mtgox", "pool",
                 "reddit", "euro", "market", "silk road", "stock", "coinbase", "worth", "blockchain",
                 "address", "difficulty", "forum", "ebay", "mt gox", "trading"]
    :keywords.save!
  end

end
