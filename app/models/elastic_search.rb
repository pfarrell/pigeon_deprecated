require 'httparty'

class ElasticSearch
  include HTTParty
  attr_accessor :host, :url, :hostname, :canonical, :date, :image, :content

  def initialize(host="http://localhost:9200")
    @host = host
  end

  def url(index, type, id)
    "#{@host}/#{index}/#{type}/#{id}"
  end

  def save(index, type, id)
    self.class.put(url(index, type, id), body: self.to_json)
  end

  def to_json(opts={}) 
    return {url: @url, host: @hostname, canonical: @canonical, image: @image, date: @date, content: @content}.to_json(opts)
  end
end
