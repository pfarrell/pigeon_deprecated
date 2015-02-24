require 'httparty'

class ElasticSearch
  include HTTParty
  attr_accessor :id, :type, :index, :host, :url, :hostname, :canonical, :date, :image, :content

  def initialize(index, type, host="http://localhost:9200")
    @host = host
    @index = index
    @type = type
  end

  def es_url
    "#{@host}/#{@index}/#{@type}/#{@id}"
  end

  def save
    self.class.put(es_url, body: self.to_json)
  end

  def to_json(opts={}) 
    return {url: @url, host: @hostname, canonical: @canonical, image: @image, date: @date, content: @content}.to_json(opts)
  end
end
