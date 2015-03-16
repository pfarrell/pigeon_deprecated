require './app'
require 'addressable/uri'

Article.each do |article|
  next if article.url.nil? || article.url.empty?
  next unless article.meta["domain"].nil? || article.meta["domain"].empty?
  puts article.url
  uri=Addressable::URI.parse(article.url)
  meta=article.meta
  meta[:domain]=uri.host
  article.meta=meta
  article.save
end

