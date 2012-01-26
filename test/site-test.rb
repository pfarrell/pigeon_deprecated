require './helpers'
require 'uri'
require 'net/http'

Link.where(:errored=>nil).each do |link|
  puts link.remote_url
  url = 'http://localhost:4567/' + link.local_url
  puts url
  r = Net::HTTP.get_response(URI.parse(url))
  puts r.code
end
