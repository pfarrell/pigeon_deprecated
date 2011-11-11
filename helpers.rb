%w(cgi mail uri mongo_mapper).each { |dependency| require dependency }

MongoMapper.connection = Mongo::Connection.new('localhost', 27017, :pool_size => 5, :timout => 5);
MongoMapper.database = 'pigeon'

class Link
  include MongoMapper::Document
  key :local_url, String
  key :remote_url, String
  key :title, String
  timestamps!
end


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
    find_links!(email.body.decoded, links)
    find_links!(email.body.decoded, links)
    email.body.parts.each do |part|
      find_links!(part.decoded, links)
    end
    links.each do |key, val|
      if Link.find_by_remote_url(key).nil?
        save_page(key, email)
      end
    end
  ensure
    email.mark(:unread)
  end
end

def find_links!(part, links)
  arr = part.split(/\s+/).find_all { |u| u =~ /^https?:/ }
  arr.each do |entry|
    if /www\.w3\.org/.match(entry).nil? \
      and /schemas\.microsoft/.match(entry).nil? \
      and /=$/.match(entry).nil?
      links[entry] = entry
    end
  end
end

def save_page(link, email) 
  mkdir!("public/sites")
  dir = String.random_alphanumeric()
  uri = URI.parse(link)
  file = link.split('/').last

  if link.match(/\/$/)
    file = 'index.html'
  end

  if !file.match(/\.html$/) && !file.match(/\.pdf$/)  
    file = file + '.html'
  end

  system("wget -qnd -pHEKk --random-wait -P public/sites/" + dir + " " + link)

  Dir.foreach("public/sites/" + dir) do |entry|
    if File.fnmatch?(file + '*html', entry) 
      file = entry
    end
  end
  
  if file.match(/\?/)
    File.rename("public/sites/" + dir + "/" + file, "public/sites/" + dir + "/index.html")
    file = 'index.html'
  end

  link = Link.new(:title=>email.subject, :remote_url=>link, :local_url=>"sites/" + dir + "/" + CGI.escapeHTML(file))
  link.save!
  system("curl -s http://localhost:4568 > public/index.html")
end

def get_links(page, limit)
  @prev = page - 1
  @next = page + 1
  page -= 1
  offset = limit * page
  Link.sort(:updated_at.desc).all(:limit=>limit, :offset=>offset)
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
