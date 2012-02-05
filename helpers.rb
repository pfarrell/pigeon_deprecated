%w(cgi uri mongo_mapper loofah htmlentities json rss/1.0 rss/2.0 open-uri).each { |dependency| require dependency }

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

class Userlink
  include MongoMapper::Document
  key :uid, String
  key :link_id, String
  key :rating, Integer
  key :date, DateTime
  timestamps!
end

class Streams
  include MongoMapper::Document
  key :uid, String
  key :name, String
  key :type, String
  key :url, String
  key :username, String
  key :password, String
  key :signal, Boolean
  timestamps!
end

class Link
  include MongoMapper::Document
  key :stream_id, String
  key :local_url, String
  key :remote_url, String
  key :content, String
  key :thumb_url, String
  key :title, String
  key :downloaded, Boolean
  key :processed, Boolean
  key :errored, String
  key :short_dir, String
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

def short_dir(size=5)
  dir = String.random_alphanumeric(size)
  while !Link.find_by_shortdir(dir).nil?
    dir = String.random_alphanumeric(size)
  end
  dir
end

def wget_filename(filename)
  retval = filename.split('/').last.gsub(/#.*/, "")

  #special case to handle test.html? which wget 
  #downloads as test.html
  if retval.match(/html\?$/)
    retval = retval.gsub(/\?$/, "")
  end

  if filename.match(/\/$/) || filename.match(/\/\?$/)
    retval = 'index.html'
  elsif filename.match(/\.html/) || filename.match(/pdf$/) || filename.match(/jp[e]?g$/) || filename.match(/gif$/)
    retval = CGI.escape(retval)
  else
    retval = CGI.escape(retval + '.html')
  end
  retval
end

def enqueue_link(redis, stream, user, remote_url, title, date) 
  link = {}
  if !user.nil?
    link[:uid] = user.uid
  end
  if !stream.nil?
    link[:stream_id] = stream.id
  end
  link[:remote_url] = remote_url
  link[:title] = title
  link[:date] = date
  redis.rpush('incoming:links', link.to_json)
end

def get_page!(link) 
  if link.remote_url.nil? || link.remote_url == ""
    link.errored = 'save_link: blank url'
    link.save! 
    return nil
  end

  mkdir!("public/sites")

  dir = short_dir() 

  file = wget_filename(link.remote_url)

  out = system("wget -qnd -pHEKk -nc --no-check-certificate --random-wait --timeout=60 -P public/sites/" + dir + " " + link.remote_url)

  link.short_dir  = dir
  link.thumb_url  = "sites/" + dir + "/favicon.ico" 
  link.local_url  = "sites/" + dir + "/" + CGI.escapeHTML(file)
  link.downloaded = true
  link.save!
  #system("curl -s http://localhost:4569 > public/index.html")
  link
end

def search_all_links(search)
  links = Link.sort(:date.desc).all(:title => {:$regex => /#{search}/i})
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
  userlinks = Userlink.where(:uid=>user.uid).sort(:date.desc).all(:limit=>limit, :offset=>offset)
  query = []
  userlinks.each {|l| query.push(l.link_id)}
  Link.sort(:date.desc).find(query)
end

def get_page_contents!(link)
  begin
    doc = Loofah.document(get_html_doc(link.remote_url))
    doc.scrub!(:whitewash)
    link.content = doc.content
    link.processed = true
    link.content = HTMLEntities.new.decode(doc.text).squeeze(" \t").strip
    link.save!
  rescue => e
    link.content = nil                                
    if (!e.nil? && !e.message.nil?)
      link.errored = 'get_page_contents: ' + e.message 
    else
      link.errored = 'get_page_contents: unknown error'
    end
    link.save!
  end
  link
end

def get_user(username) 
  User.find_by_username(username)
end

def get_streams(user)
  Streams.where(:uid=>user.uid).all
end

def get_rss(url)
  RSS::Parser.parse(get_html_doc(url), false)
end  

def get_html_doc(url)
  content = ""
  open(url) do |s| content = s.read end
  content
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
