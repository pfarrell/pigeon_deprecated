require './app'

scraper = Scraper.new

doc = scraper.scrape(ARGV[0])
puts doc.headers
=begin
puts doc.title
puts doc.images.inspect
puts doc.links.inspect
puts doc.external_links.inspect
puts doc.internal_links.inspect
puts doc.headings.inspect
puts doc.headings(2).inspect
puts doc.headings(3).inspect
puts doc.headings(4).inspect
puts doc.headings(5).inspect
=end

