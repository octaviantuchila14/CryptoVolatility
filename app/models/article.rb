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

  def time_span
    day = DateTime.now.day - self.published_at.day
    hour = DateTime.now.hour - self.published_at.hour
    min = DateTime.now.min - self.published_at.min

    res = ""

    res << "#{day} day " if(day == 1)
    res << "#{day} days " if(day > 1)
    res << "#{hour} hour " if(hour == 1)
    res << "#{hour} hours " if(hour > 1)
    res << "#{min} minute " if(min == 1)
    res << "#{min} minutes " if(min > 1)

    res
  end

  private

  def self.add_entries(entries)
    entries.sort_by!{|entry| entry.published}
    entries.each do |entry|
      if Article.where(guid: entry.id).empty?
        create!(
            name:            entry.title,
            url:             entry.url,
            summary:         ActionView::Base.full_sanitizer.sanitize(entry.summary),
            published_at:    entry.published,
            guid:            entry.id
        )
      end
    end
  end

end
