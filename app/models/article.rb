require 'byebug'
require 'date'

class Article < Sequel::Model
  many_to_one :source
  many_to_many :links

  def source_urls
    ret = Hash[links.collect{|link| [link.type, link.url]}]
  end

  def self.parse(item, feed) 
    article = self.new
    case(feed)
      when RSS::Rss
        return self.from_rss(item)
      when RSS::Atom::Feed
        return self.from_atom(item)
      else
        raise "Unhandled feed type: [#{feed.class}]"
      end
  end
    
  def self.from_rss(item)
    article = self.new(title: item.title, date: item.pubDate || DateTime.now)
    article.links << Link.new(type: "content", url: "#{item.link}")
    article.links << Link.new(type: "comments", url: "#{item.comments}")
    article
  end

  def self.from_atom(item)
    article = self.new(title: item.title.content, date: item.published || DateTime.now)
    article.links << Link.new(type: "content", url: "#{item.id.content}")
    article
  end
end
