require 'rss'
require 'open-uri'

class RssFeed < Source

  def articles
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      if block_given?
        feed.items.each{|item| yield Article.parse(item, feed) }
      else
        feed.items.map{|item| Article.parse(item, feed) }
      end
    end
  end
end
