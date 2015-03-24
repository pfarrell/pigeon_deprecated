require './app'

scraper = Scraper.scrape(ARGV[0])
puts "meta : #{scraper.doc.meta.inspect}\n\n"
puts "favic: #{scraper.doc.favicon}\n\n"
puts "canon: #{scraper.doc.canonical}\n\n"
puts "title: #{scraper.doc.title}\n\n"
puts "imgs : #{scraper.doc.images.inspect}\n\n"
puts "links: #{scraper.doc.links.inspect}\n\n"
puts "ext_l: #{scraper.doc.external_links.inspect}\n\n"
puts "int_l: #{scraper.doc.internal_links.inspect}\n\n"
puts "h1   : #{scraper.doc.headings.inspect}\n\n"
puts "h2   : #{scraper.doc.headings(2).inspect}\n\n"
puts "h3   : #{scraper.doc.headings(3).inspect}\n\n"
puts "h4   : #{scraper.doc.headings(4).inspect}\n\n"
puts "h5   : #{scraper.doc.headings(5).inspect}\n\n"

puts "img_s: #{scraper.sort_file_sizes(ARGV[0], scraper.doc.images)}"
