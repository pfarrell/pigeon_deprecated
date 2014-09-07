require 'rss'
require 'open-uri'

class RssFeed < Source

  def articles
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      if block_given?
        feed.items.each do |item|
          a = Article.new(title: item.title)
          a.links << Link.new(type: "content", url: item.link)
          a.links << Link.new(type: "comments", url: item.comments)
          yield a
        end
      else
        feed.items.map do |item| 
          a = Article.new(title: item.title)
          a.links << Link.new(type: "content", url: item.link)
          a.links << Link.new(type: "comments", url: item.comments)
          a
        end
      end
    end
  end
end
