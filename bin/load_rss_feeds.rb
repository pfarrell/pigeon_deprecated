require './app'
require 'json'

sources_json = File.readlines(ARGV[0])

sources_json.each do |source|
  hsh = JSON.parse(source)
  next if hsh["url"].nil? || hsh["url"] == ""
  source = RssFeed.find_or_create(url: hsh["url"], title: hsh["name"], type: "rss")
end

