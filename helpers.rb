%w(mail uri).each { |dependency| require dependency }

def String.random_alphanumeric(size=16)
  s = ""
  size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
  s
end

def mkdir!(directory) 
  if !FileTest::directory?(directory)
    Dir::mkdir(directory)
  end
end

def process!(email)
  begin
    links = {}
    email.body.parts.each do |part|
      find_links!(part.decoded, links)
    end
    links.each do |key, val|
      puts key
      save_page(key)
    end
  ensure
    email.mark(:unread)
  end
end

def find_links!(part, links)
  arr = part.scan(/http[s]?:\/\/[a-zA-Z0-9\/\.\_-]*/)
  arr.each do |entry|
    if /www\.w3\.org/.match(entry).nil? \
      and /schemas\.microsoft/.match(entry).nil?
      links[entry] = entry
    end
  end
end

def save_page(link) 
  mkdir!("public/sites")
  dir = String.random_alphanumeric()
  uri = URI.parse(link)
  file = link.split('/').last
  if link.match(/\/$/)
    file = 'index.html'
  end
  if !file.match(/\.html$/)  
    file = file + '.html'
  end
  system("wget -qnd -pHEKk --random-wait -P public/sites/" + dir + " " + link)
  File.open("views/index.haml", 'a') do |f| 
    f.write("  %div\n")
    f.write("    %a{:href=>'sites/" + dir + '/' + file + "'}\n") 
    f.write("      " + link + "\n")
  end
  #File.open("sites/index.html", 'a') {|f| f.write("<div><a href='" + dir + '/' + file + "'>" + link + "</a></div>")}
end

def partial(template, *args)
  options = args.last.is_a?(Hash) ? args.pop : { }
  options.merge!(:layout => false)
  if collection = options.delete(:collection) then
    haml_concat(collection.inject([]) do |buffer, member|
    buffer << haml(template, options.merge(
      :layout => false,
      :locals => {template.to_sym => member}
      )
    )
    end.join("\n"))
  else
    haml_concat(haml(template, options))
  end
end

def ajax?
  request.xhr?
end
