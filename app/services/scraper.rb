require 'nokogiri'
require 'open-uri'
require 'addressable/uri'

class Scraper
  attr_accessor :doc, :url, :final

  def self.scrape(url)
    s=Scraper.new
    s.url = url
    s.final = s =~ /http/ ? s.final_url(s.uri(url)) : url
    s.doc = Html.new(url: s.final, content: open(s.final))
    s
  end

  def uri(url)
    Addressable::URI.parse(url)
  end

  def favicon(url)
    "#{uri(url).origin}/favicon.ico"
  end

  def final_url(url)
    u=uri(url)
    page_head=head(u)
    case page_head.code
      when "301"
        return u.to_s if u.to_s == page_head['location']
        return final_url(page_head['location'])
      when "200"
        return u.to_s 
    end
  end  
  
  def head(url)
    u = uri(url)
    Net::HTTP.start(u.host, u.port, use_ssl: (u.scheme == "https")) {|http| http.head(u.normalized_path) }
  end

  def sort_file_sizes(base_url, urls)
    urls.sort_by{ |url| 
      uri = uri(normalize(uri(base_url).origin, url))
      len= head(uri).content_length
      len * -1 unless len.nil?
    }
  end

  def normalize(base, url)
    return url if url =~ /^http/
    return "#{base}#{url}"
  end

end

class Html
  attr_accessor :doc, :uri
  # bigger images are more important?
  # external links are more important?
  # repeated links/image are less important?
  # functions not memoized because i don't have that problem atm

  def initialize(opts={})
    @doc= Nokogiri::HTML(opts[:content]) unless opts[:doc]
    @uri= Scraper.new.uri(opts[:url]) unless opts[:url].nil?
  end

  def host
    @uri.host
  end

  def content
    @doc.css("body").to_s
  end

  def scheme
    @uri.scheme
  end

  def normalize(path)
    ret="#{scheme}:#{path}" if path =~ /^\/\//
    ret || path
  end

  def title
    @doc.title
  end

  def favicon
    link = select("link").select{|x| x["rel"]=~ /icon/}.first
    return normalize(link["href"]) unless link.nil?
    Scraper.new.favicon(@uri.to_s)
  end

  def select(selector)
    @doc.css(selector)
  end
    

  def meta
    @doc.css("meta").map{|x| x.first }.to_h
  end
  
  def canonical
    links= @doc.css("link").select{|x| x["rel"]=="canonical"}
    return [] if links.size==0
    warn "more than one canonical link found" if links.size > 1
    links.first["href"]
  end

  def headings(level="1")
    @doc.css("h#{level}").select{|x| !x.text.nil?}.map{|x| x.text}
  end

  def images
    @doc.css('img').map{|x| normalize(x.attributes["src"].value) unless x.attributes["src"].nil? }
  end

  def links
    @doc.css('a').map{|x| x.attributes["href"].value unless x.attributes["href"].nil? }
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
