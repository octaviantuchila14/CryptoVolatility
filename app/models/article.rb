class Article < ActiveRecord::Base
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
