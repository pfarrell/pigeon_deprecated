%w(cgi uri mongo_mapper loofah htmlentities feedzirra json open-uri).each { |dependency| require dependency }

MongoMapper.connection = Mongo::Connection.new('localhost', 27017, :pool_size => 5);
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

class Streams
  include MongoMapper::Document
  key :uid, String
  key :name, String
  key :type, String
  key :url, String
  key :username, String
  key :password, String
  key :signal, Boolean
  key :count, Integer
  timestamps!
end

class Link
  include MongoMapper::Document
  key :stream_id, String
  key :local_url, String
  key :remote_url, String
  key :content, String
  key :clean_content, String
  key :raw_content, String
  key :thumb_url, String
  key :title, String
  key :downloaded, Boolean
  key :processed, Boolean
  key :errored, String
  key :short_dir, String
  key :date, DateTime
  key :link, String
  timestamps!
end

class Userlink
  include MongoMapper::Document
  key :uid, String
  key :link_id, ObjectId
  key :deleted, Boolean
  key :date, DateTime
  key :link, Link
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
    #email.mark(:unread)
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

def enqueue_link(redis, stream, user, remote_url, title, date, front=false) 
  link = {}
  if !user.nil?
    link[:uid] = user.uid
  end
  if !stream.nil?
    link[:stream_id] = stream.id.to_s
  end
  link[:remote_url] = remote_url
  link[:title] = title
  link[:date] = date
  if(front)
    redis.lpush('incoming:links', link.to_json)
  else
    redis.rpush('incoming:links', link.to_json)
  end
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

def search_raw_links(search)
  Link.sort(:date.desc).all(:content => {:$regex => /#{search}/i})
end

def search_user_links(user, search)
  retval = []
  Link.sort(:date.desc).all(:content => {:$regex => /#{search}/i}).each do |l|
    ul = Userlink.where(:link_id=>l.id).first
    if(!ul.nil?)
      ul.link = l
      retval.push(ul)
    end
  retval
  end
end

def get_links(user, page, limit)
  @prev = page - 1
  @next = page + 1
  #page -= 1
  offset = limit * page
  userlinks = Userlink.where(:uid=>user.uid, :deleted=>nil).sort(:date.desc).all(:limit=>limit, :offset=>offset)
  resolve_link_dependencies(userlinks)
end

def resolve_link_dependencies(userlinks)
  userlinks.each do |ul|
    ul.link = Link.find(ul.link_id)
    puts ul.link.nil?
  end
  userlinks
end

def get_deleted_links(user, page, limit)
  @prev = page - 1
  @next = page + 1
  #page -= 1
  offset = limit * page
  userlinks = Userlink.where(:uid=>user.uid, :deleted=>true).sort(:date.desc).all(:limit=>limit, :offset=>offset)
  userlinks.each do |ul|
    ul.link = Link.find(ul.link_id)
    puts ul.link
  end
  userlinks
end

def get_raw_links(user, page, limit)
  @prev = page - 1
  @next = page + 1
  #page -= 1
  offset = limit * page
  Link.sort(:date.desc).all(:limit=>limit, :offset=>offset)
end

def get_stream_links(stream_name, page, limit)
  @prev = page - 1
  @next = page + 1
  #page -= 1
  offset = limit * page
  stream = Streams.find_by_name(stream_name)
  Link.sort(:date.desc).all(:stream_id=>stream.id.to_s, :limit=>limit, :offset=>offset)
end

def get_page_contents!(link)
  begin
    source = get_html_doc(link.remote_url)
    doc = Loofah.document(source)
    doc.scrub!(:whitewash)
    link.content = doc.content
    link.raw_content = source
    link.processed = true
    link.content = HTMLEntities.new.decode(doc.text).squeeze(" \t").strip
    link.save!
  rescue => e
    link.content = nil                                
    link.raw_content = nil
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
  streams = Streams.where(:uid=>user.uid).all
  streams.each do |s|
    s.count = Link.where(:stream_id=>s.id.to_s).count
  end
  streams
end

def get_rss(url)
  ret = nil
  Timeout::timeout(20) do
    ret = Feedzirra::Feed.fetch_and_parse(url)
  end
  ret
end  

def get_stats(user)
  retval = {} 
  retval["User Links"] = Userlink.where(:uid=>user.uid).count.to_s
  retval["System Links"] = Link.count

  retval
end

def get_html_doc(url)
  content = ""
  open(url) do |s| content = s.read end
  if !content.utf8?
    content = content.asciify_utf8
  end
  content
  #if !content.utf8?
  #  content = content.asciify_utf8
  #end
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
