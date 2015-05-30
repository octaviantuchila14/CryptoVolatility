namespace :cssfeed do

  task get_articles: :environment do
    p 'getting articles'
    Article.update_from_feed("http://feeds.feedburner.com/CoinDesk")
  end

end


