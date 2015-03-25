require 'open-uri'
require 'simple-rss'

class RssFeed < Source
  def articles
    feed = SimpleRSS.parse open(url)
    if block_given?
      feed.items.each{|item| yield Article.parse(item, feed) }
    else
      feed.items.map{|item| Article.parse(item, feed) }
    end
  end
end
