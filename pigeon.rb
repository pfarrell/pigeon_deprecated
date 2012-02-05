%w(yaml gmail mongo_mapper redis rss/1.0 rss/2.0 open-uri ./helpers).each { |dependency| require dependency }

def do_gmail(redis, user, stream)
	gmail = Gmail.new(stream.username, stream.password)do |gmail|
	  gmail.inbox.emails(:unread).each do |email|
	    extract_links(email).each do |url, val|
        begin
          enqueue_link(redis, stream, user, url, email.subject, email.date)
        rescue => e
          puts e.message
          email.mark(:unread)
        end
      end
	  end
	end
end

def do_rss(redis, stream)
  rss = get_rss(stream.url)
  rss.items.each do |item|
    enqueue_link(redis, stream, nil, item.link, item.title, Time.new)
  end
end

redis = Redis.new

User.all().each do |user|
  Streams.where(:uid=>user.uid).each do |stream|
    if stream.type.downcase == 'gmail'
      do_gmail(redis, user, stream)
    elsif stream.type.downcase == 'rss'
      do_rss(redis, stream) 
    end
  end
end

while(redis.llen('incoming:links') > 0)
  hash = JSON.parse(redis.lpop('incoming:links'))
  puts hash['remote_url']
  link = nil
  if Link.where(:remote_url=>hash['remote_url']).count == 0
    link = Link.new(:title=>hash['title'], :date=>hash['date'], :downloaded=>false, :processed=>false, :remote_url=>hash['remote_url'])
    link = get_page_contents!(link)
    link.save!
  end

  if !link.nil? && !hash['uid'].nil?
    puts 'creating userlink'
    link = get_page!(link)
    userlink = Userlink.new(:uid=>hash['uid'], :link_id=>link.id, :date=>hash['date'])
    userlink.save!
  end
end
