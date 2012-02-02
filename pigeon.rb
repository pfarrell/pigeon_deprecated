%w(yaml gmail mongo_mapper redis rss/1.0 rss/2.0 open-uri ./helpers).each { |dependency| require dependency }

def do_gmail(redis, user, username, password)
	gmail = Gmail.new(username, password)do |gmail|
	  gmail.inbox.emails(:unread).each do |email|
	    extract_links(email).each do |key, val|
       if Link.find_by_remote_url(key).nil?
         begin
           enqueue_user_link(redis, user, key, email.subject, email.date)
         rescue => e
           puts e.message
           email.mark(:unread)
         end
        end
      end
	  end
	end
end

def do_rss(redis, stream)
  rss = get_rss(stream.url)
  rss.items.each do |item|
    enqueue_rss_link(redis, stream, item.link, item.title, Time.new)
  end
end

redis = Redis.new

User.all().each do |user|
  Streams.where(:uid=>user.uid).each do |stream|
    if stream.type.downcase == 'gmail'
      do_gmail(redis, user, stream.username, stream.password)
    elsif stream.type.downcase == 'rss'
      do_rss(redis, stream) 
    end
  end
end

while(redis.llen('incoming:links') > 0)
  hash = JSON.parse(redis.lpop('incoming:links'))

  if !hash[:uid].nil?
    if !Link.find(:uid=>hash['uid'], :remote_url=>hash['remote_url'])
      link = Link.new(:uid=>hash['uid'], :title=>hash['title'], :date=>hash['date'], :downloaded=>false, :processed=>false, :remote_url=>hash['remote_url'])
      link.save!
    end

    link = get_page!(link)

    link = get_page_contents!(link)
  else
    #generic link
  end
end
