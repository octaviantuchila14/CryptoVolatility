namespace :cssfeed do

  task get_articles: :environment do
    Article.update_from_feed("http://feeds.feedburner.com/CoinDesk")
  end

  # task parse_google_keywords, [:full_name] do
  #   p full_name
  # end

end


