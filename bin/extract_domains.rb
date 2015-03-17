require './app'
require 'addressable/uri'

ctr=0
Article.each do |article|
  ctr += 1
  if ctr % 500 == 0
    print '.'
    STDOUT.flush
  end

  next if article.url.nil? || article.url.empty?
  next unless article.meta.nil? || article.meta["domain"].nil? || article.meta["domain"].empty?
  begin
    uri=Addressable::URI.parse(article.url)
    meta=article.meta || {}
    meta[:domain]=uri.host
  rescue Exception => ex
    puts "article: #{article.inspect}"
  end
  article.meta=meta
  article.save
end

