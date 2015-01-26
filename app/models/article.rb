require 'date'

class Article < Sequel::Model
  many_to_one :source
  many_to_many :links

  def source_urls
    Hash[links.collect{|link| [link.type, link.url]}]
  end

  # should allow instantiation by direct argument, this method
  # implicitly ties us to SimpleRss
  def self.parse(item, feed) 
    self.from_rss(item)
  end
    
  def self.from_rss(item)
    article = self.new(title: item.title, url: item.link)#, date: item.pubDate || DateTime.now)
    article.links << Link.new(type: "content", url: "#{item.link}")
    article.links << Link.new(type: "comments", url: "#{item.comments}")
    article
  end
end
