require 'nokogiri'
require 'open-uri'
require 'addressable/uri'

class Scraper

  def scrape(url)
    Html.new(url, Nokogiri::HTML(open(url)))
  end

end

class Html
  attr_accessor :raw, :uri 
  # bigger images are more important?
  # external links are more important?
  # repeated links/image are less important?
  # functions not memoized because i don't have that problem atm

  def initialize(url, doc)
    @raw = doc
    @uri=Addressable::URI.parse(url)
  end

  def host
    @uri.host
  end

  def content
    @raw.to_s
  end

  def title
    @raw.title
  end
  
  def headings(level="1")
    @raw.css("h#{level}").select{|x| !x.text.nil?}.map{|x| x.text}
  end

  def images
    @raw.css('img').map{|x| x.attributes["src"].value unless x.attributes["src"].nil? }
  end

  def links
    @raw.css('a').map{|x| x.attributes["href"].value unless x.attributes["href"].nil? }
  end


  def headers(uri=@uri)
    response=nil
    Net::HTTP.start(uri.host, uri.port) {|http|
     response = http.head(uri.path)
    byebug
    }.header.to_hash
  end

  def external_links
    links.select do |x| 
      uri=Addressable::URI.parse(x)
      uri.host != host
    end
  end

  def internal_links
    links.select do |x| 
      uri=Addressable::URI.parse(x)
      uri.host == host
    end
  end
end
