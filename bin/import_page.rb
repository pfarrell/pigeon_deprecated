require './app.rb'

def import_page(url)
  require 'byebug'
  #byebug
  begin
    puts 'initialize es'
    es = ElasticSearch.new("pigeon", "page")
    puts 'scrape page'
    page = Scraper.scrape(url)
    puts 'get article'
    article = Article.find_or_create(url: url, title: page.doc.title)
    puts "article_id: #{article.id}"
    es.id = article.id
    es.content = page.doc.content
    es.date = article.created_at.to_s.sub(/ /, "T").sub(/ .*/, '')
    puts "save to es"
    es.save
  rescue Exception => ex
    $stderr.puts("error getting #{url}: #{ex.message}")
  end
end

import_page(ARGV[0])
