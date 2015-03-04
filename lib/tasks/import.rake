require 'json'
require 'htmlentities'


namespace :import do
  def import_feed(feed) 
    ent = HTMLEntities.new
    begin
      feed.articles.each do |article|
        next unless Article.first(url: article.url, title: (ent.decode(article.title)), source: feed).nil?
        article.source = feed
        article.title = ent.decode(article.title)
        article.save
      end
    rescue Exception => ex
      $stderr.puts("error getting #{feed.url}: #{ex.message}")
    end
  end

  task :feed, [:id] do |t, args|
    import_feed(RssFeed[args[:id].to_i])
  end

  task :feeds do  
    RssFeed.all.each{|feed| import_feed(feed) }
  end

  task :list do
    RssFeed.all.each {|feed| print "[#{feed.id}] #{feed.title.strip}\n"}
  end

  task :process do
    redis = Redis.new
    ent = HTMLEntities.new
    json = redis.lpop("incoming:links")
    unless(json.nil?)
      obj = JSON.parse(json)
      article = Article.find_or_create(:url => obj['url'])
      article.title = ent.decode(obj['title']) unless obj['title'].nil?
      article.date = obj['date' || DateTime.now]
      article.save
      capture = Capture.new(:article => article)
      capture.date = obj['date'] || DateTime.now
      capture.download!
      capture.save
    end
  end

  task :drain do
    redis = Redis.new
    ent = HTMLEntities.new
    json = redis.lpop("incoming:links")
    until(json.nil?)
      obj = JSON.parse(json)
      article = Article.new
      article.url = obj['url']
      article.title = ent.decode(obj['title']) unless obj['title'].nil?
      article.date = obj['date'] || DateTime.now
      article.save
      capture = Capture.new(:article => article)
      capture.date = obj['date'] || DateTime.now
      capture.download!
      capture.save
      json = redis.lpop("incoming:links")
    end
  end
end
