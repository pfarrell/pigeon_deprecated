require 'rss'
require 'open-uri'

class RssFeed < Source

  def articles
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      if block_given?
        feed.items.each{|item| yield Article.new(url: item.link, title: item.title)}
      else
        feed.items.map{|item| Article.new(url: item.link, title: item.title)}
      end
    end
  end
end
