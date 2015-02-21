require 'date'
require 'sanitize'
require 'byebug'

class Article < Sequel::Model
  many_to_one :source
  many_to_many :links
  one_to_many :capture

  def source_urls
    Hash[links.collect{|link| [link.type, link.url]}]
  end

  # should allow instantiation by direct argument, this method
  # implicitly ties us to SimpleRss
  def self.parse(item, feed) 
    self.from_rss(item)
  end
    
  def self.from_rss(item)
    article = self.new(title: encode(item.title), url: item.link)#, date: item.pubDate || DateTime.now)
    article.links << Link.new(type: "content", url: "#{item.link}")
    article.links << Link.new(type: "comments", url: "#{item.comments}")
    article
  end

  def content
    byebug
  end

  def self.encode(str)
    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :universal_newline => true       # Always break lines with \n
    }
    str.encode(Encoding.find('ASCII'), encoding_options)
  end
end
