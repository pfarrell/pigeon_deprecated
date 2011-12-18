%w(cgi mail uri mongo_mapper).each { |dependency| require dependency }

MongoMapper.connection = Mongo::Connection.new('localhost', 27017, :pool_size => 5, :timout => 5);
MongoMapper.database = 'pigeon'

class User 
  include MongoMapper::Document
  key :uid, String
  key :name, String
  key :username, String
  key :nickname, String
  key :description, String
  timestamps!
end

class Credentials
  include MongoMapper::Document
  key :username, String
  key :password, String
end

class Stream
  include MongoMapper::Document
  key :uid, String
  key :name, String
  key :type, String
  key :credentials, Credentials
  key :signal, Boolean
  timestamps!
end

class Link
  include MongoMapper::Document
  key :uid, String
  key :local_url, String
  key :remote_url, String
  key :thumb_url, String
  key :title, String
  key :signal, Boolean
  key :date, DateTime
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

def process_part(part) 
  links = Hash.new
  if part.multipart?
    part.part.each do |p|
      process_part(p).each do |key, vall|
        links[key] = vall
      end
    end
  else
    find_links(part.decoded).each do |key, val|
      links[key] = val
    end
  end

  links
end

def extract_links(email)
  links = Hash.new
  begin
    find_links(email.body.decoded).each do |key, val|
      links[key] = val
    end
    
    email.body.parts.each do |part|
      process_part(part).each do |key, val|
        links[key] = val
      end
    end
  ensure
    email.mark(:unread)
  end
  links
end

def find_links(text)
  links = Hash.new
  arr = text.split(/\s+/).find_all { |u| u =~ /^https?:/ }
  arr.each do |entry|
    if /www\.w3\.org/.match(entry).nil? \
      and /schemas\.microsoft/.match(entry).nil? \
      and /=$/.match(entry).nil?
      links[entry] = entry
    end
  end

  links
end

def random_dir(base, size=16)
  if base.nil? || base == ''
    base = '.'
  end
  
  dir = String.random_alphanumeric(size)
  while test ?d, base + '/' + dir
    dir = String.random_alphanumeric(size)
  end
  base + '/' + dir
end

def save_page(user, link, email) 
  mkdir!("public/sites")
  uri = URI.parse(link)
  dir = uri.host

  file = link.split('/').last

  if link.match(/\/$/)
    file = 'index.html'
  end

  if !file.match(/\.html$/) && !file.match(/\.pdf$/)  
    file = file + '.html'
  end

  system("wget -qnd -pHEKk -nc --random-wait --timeout=60 -P public/sites/" + dir + " " + link)

  Dir.foreach("public/sites/" + dir) do |entry|
    if File.fnmatch?(file + '*html', entry) 
      file = entry
    end
  end
  
  if file.match(/\?/)
    File.rename("public/sites/" + dir + "/" + file, "public/sites/" + dir + "/index.html")
    file = 'index.html'
  end

  link = Link.new(:uid=>user.uid, :title=>email.subject, :date=>email.date, :thumb_url=> "sites/" + dir + "/favicon.ico", :remote_url=>link, :local_url=>"sites/" + dir + "/" + CGI.escapeHTML(file))
  link.save!
  system("curl -s http://localhost:4569 > public/index.html")
end

def search_links(user, search)
  links = Link.where(:uid=>user.uid).sort(:date.desc).all(:title => {:$regex => /#{search}/i})
  if links.nil?
    links = 'Confounded!!!'
  end
  links
end

def get_links(user, page, limit)
  @prev = page - 1
  @next = page + 1
  #page -= 1
  offset = limit * page
  Link.where(:uid=>user.uid).sort(:date.desc).all(:limit=>limit, :offset=>offset)
end

def get_user(username) 
  User.find_by_username(username)
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
