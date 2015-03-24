require 'nokogiri'
require 'open-uri'
require 'addressable/uri'

class Scraper
  attr_accessor :doc, :url, :uri, :final

  def initialize(url=nil)
    @url=url
    @uri=uri(url)
    @final=final(@uri)
    @doc=Html.new(@final, Nokogiri::HTML(open(@final)))
  end

  def self.scrape(url)
    Scraper.new(url)
  end

  def uri(url)
    Addressable::URI.parse(url)
  end

  def favicon
    "#{@uri.origin}/favicon.ico"
  end

  def final(uri)
    page_head=head(uri)
    case page_head.code
      when "301"
        return uri.to_s if uri.to_s == page_head['location']
        return final(uri(page_head['location']))
      when "200"
        return uri.to_s 
    end
  end  
  
  def head(uri)
    Net::HTTP.start(uri.host, uri.port) {|http| http.head(uri.normalized_path) }
  end

  def sort_file_sizes(base_url, urls)
    urls.sort_by{ |url| 
      uri = uri(normalize(uri(base_url).origin, url))
      head(uri).content_length * -1
    }
  end

  def normalize(base, url)
    return url if url =~ /^http/
    return "#{base}#{url}"
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

  def scheme
    @uri.scheme
  end

  def normalize(path)
    ret="#{scheme}:#{path}" if path =~ /^\/\//
    ret || path
  end

  def title
    @raw.title
  end

  def favicon
    link = select("link").select{|x| x["rel"]=~ /icon/}.first
    return normalize(link["href"]) unless link.nil?
    Scraper.favicon(@uri)
  end

  def select(selector)
    @raw.css(selector)
  end
    

  def meta
    @raw.css("meta").map{|x| x.first }.to_h
  end
  
  def canonical
    links= @raw.css("link").select{|x| x["rel"]=="canonical"}
    return [] if links.size==0
    warn "more than one canonical link found" if links.size > 1
    links.first["href"]
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

  def external_links
    links.select do |x| 
      uri=Addressable::URI.parse(x)
      !uri.host.nil? && !host.nil? && !host.end_with?(uri.host) && (uri.to_s =~ /^(\/|#)/).nil?
    end
  end    

  def internal_links
    links.select do |x| 
      uri=Addressable::URI.parse(x)
      !host.nil? || host.end_with?(uri.host) || uri.to_s =~ /^(\/|#)/
    end
  end
end
