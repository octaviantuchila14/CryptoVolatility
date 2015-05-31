class Article < ActiveRecord::Base

  has_many :influences

  after_create :get_classifications

  def get_classifications
    Knn.all.each do |knn|
      if(knn.currency.full_name == 'Bitcoin') #classify only for Bitcoin at first
        self.influences << knn.classify_article(self.summary, self.published_at)
      end
    end
  end

  def self.update_from_feed(feed_url)
    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
  end

  def self.update_from_feed_continuously(feed_url, delay_interval = 15.minutes)
    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
    loop do
      sleep delay_interval
      feed = Feedjira::Feed.update(feed)
      add_entries(feed.new_entries) if feed.updated?
    end
  end

  private

  def self.add_entries(entries)
    entries.each do |entry|
      pp entry
      if Article.where(guid: entry.id).empty?
        create!(
            name:            entry.title,
            url:             entry.url,
            summary:         strip_tags(entry.summary),
            published_at:    entry.published,
            guid:            entry.id
        )
      end
    end
  end
end
