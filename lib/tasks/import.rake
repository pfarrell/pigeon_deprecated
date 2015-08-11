require 'json'
require 'uri'
require 'htmlentities'


namespace :import do
  def scrape_title(url)
    scraper = Scraper.scrape(url)
    scraper.doc.title
  end

  def import_feed(feed) 
    redis = Redis.new
    ent = HTMLEntities.new
    begin
      feed.articles.each do |article|
        title=ent.decode(article.title)
        next unless Article.first(url: article.url, title: title, source: feed).nil?
        uri = URI(article.url)
        article.source = feed
        article.title = title
        article.meta={}
        article.meta[:domain]= uri.host
        article.meta[:comments]=article.comments.first.url unless article.comments.nil? || article.comments.empty?
        article.save
      end
    rescue Exception => ex
      $stderr.puts("error getting #{feed.url}: #{ex.message}")
    end
  end

  def import_page(url)
    require 'byebug'
    #byebug
    begin
      puts 'initialize es'
      es = ElasticSearch.new("pigeon", "page")
      puts 'scrape page'
      page = Scraper.scrape(url)
      puts 'get article'
      article = Article.find_or_create(url: url, title: page.doc.title)
      puts "article_id: #{article.id}"
      es.id = article.id
      es.content = page.doc.content
      puts "save to es"
      es.save
    rescue Exception => ex
      $stderr.puts("error getting #{url}: #{ex.message}")
    end
  end

  task :page, [:url] do |t, args|
    import_page(args[:url])
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
      uri = URI(obj['url'])
      article = Article.find_or_create(url: obj['url'])
      article.title ||= ent.decode(obj['title']) unless obj['title'].nil?
      article.date = obj['date' || DateTime.now]
      article.meta ||= {}
      article.meta[:domain] ||= uri.host
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
      unless obj['url'].nil?
        uri = URI(obj['url']) 
        article = Article.find_or_create(:url => obj['url'])
        article.title ||= ent.decode(obj['title']) unless obj['title'].nil?
        article.title = scrape_title(obj['url']) if article.title.nil?
        article.date ||= obj['date'] || DateTime.now
        article.meta ||= {}
        article.meta[:domain] ||= uri.host
        article.save
        capture = Capture.new(:article => article)
        capture.date = obj['date'] || DateTime.now
        capture.download!
        capture.save
      end
      json = redis.lpop("incoming:links")
    end
  end
end
