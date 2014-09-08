require './app'
require 'json'

sources_json = File.readlines(ARGV[0])

sources_json.each do |source|
  hsh = JSON.parse(source)
  source = RssFeed.find_or_create(url: hsh["url"], title: hsh["name"], type: "rss")
end

