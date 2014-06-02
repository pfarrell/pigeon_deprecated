require './helpers'

Link.where(:content => nil, :processed=>false).each do |link|
  begin
    if(link.remote_url =~ /pdf$/)
    else
      puts link.remote_url
      source = get_html_doc(link.remote_url)
      doc = Loofah.document(source)
      doc.scrub!(:whitewash)
      link.raw_content = source
      link.processed = true
      link.content = HTMLEntities.new.decode(doc.text).squeeze(" \t").strip
      link.save! 
    end
  rescue => e
    link.processed=true
    link.errored=e.message
    link.raw_content=''
    link.content=''
    link.save! 
  end
end
