require './app'
require 'json'
require 'byebug'


File.open(ARGV[0], "r") do |file_handle|
  file_handle.each_line do |line|
    hsh = JSON.parse(line)
    article = Article.find_or_create(:url => hsh['remote_url'])
    article.save
    date = Time.at(hsh['date']['$date'].to_i / 1000)
    capture = Capture.find_or_create(:article => article, :date => date)
    capture.url = hsh['local_url']
    capture.save
  end
end
