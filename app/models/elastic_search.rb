require 'httparty'

class ElasticSearch
  include HTTParty
  attr_accessor :host

  def initialize(host="http://localhost:9200")
    @host = host
  end

  def url(index, type, id)
    "#{@host}/#{index}/#{type}/#{id}"
  end

  def save(index, type, id, json)
    self.class.put(url(index, type, id), body: json)
  end
end
