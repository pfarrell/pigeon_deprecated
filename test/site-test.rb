require './helpers'
require 'uri'
require 'net/http'

report = {}
Link.where(:errored=>nil).each do |link|
  url = 'http://localhost:4567/' + link.local_url
  r = Net::HTTP.get_response(URI.parse(url))
  report[r.code] = report[r.code].nil? ? 1 : report[r.code] + 1
end

puts "status\tcount"
report.each do |key,val|
  puts key.to_s + "\t" + val.to_s
end
