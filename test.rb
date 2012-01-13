require 'nokogiri'
require 'loofah'
require './helpers'
require 'cgi'


#f = File.open(

doc = Loofah.document(File.read("public/" + Link.where(:downloaded=>true).first.local_url))
doc.scrub!(:whitewash)
puts CGI::unescapeHTML(doc.text)
#body['style'] = "background-color: blue;"
#html = doc.to_html
 
#puts html
