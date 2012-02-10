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
  puts stream.url
  rss = get_rss(stream.url)
  rss.items.each do |item|
    enqueue_link(redis, stream, nil, item.link, item.title, Time.new)
  end
end

def validate_pid(file_name)
  retval = false
  if !File.exists?(file_name)
    generate_pid(file_name, $$)
    retval = true
  else
    file_pid = open(file_name).gets
    begin
      Process.kill 0, file_pid.to_i
    rescue
      generate_pid(file_name, $$)
      retval = true
    end
  end
  retval
end

def generate_pid(file_name, process_id)
  File.open(file_name, 'w+') {|f| f.write($$) }
end
if validate_pid("/tmp/pigeon.pid")
  iter = -1
  redis = Redis.new

  while(true)
    iter = iter + 1
    User.all().each do |user|
      Streams.where(:uid=>user.uid).each do |stream|
        if stream.type.downcase == 'gmail'
          do_gmail(redis, user, stream)
        elsif stream.type.downcase == 'rss'
          if iter % 40 == 0  # only parse rss feeds every 15 minutes
            do_rss(redis, stream) 
          end
        end
      end
    end
    
    while(redis.llen('incoming:links') > 0)
      hash = JSON.parse(redis.lpop('incoming:links'))
      link = Link.where(:remote_url=>hash['remote_url']).first
      if link.nil? 
        puts 'creating link'
        link = Link.new(:title=>hash['title'], :date=>hash['date'], :downloaded=>false, :processed=>false, :remote_url=>hash['remote_url'])
        link.save!
        link = get_page_contents!(link)
        link.save!
        puts 'link: ' + link.inspect
      else
      end
      
      if !link.nil? && !hash['uid'].nil? 
        puts 'adding to user'
        if !link.downloaded
          puts 'downloading'
          link = get_page!(link)
          puts 'downloaded: ' + link.inspect
        end
        puts 'new userlink'
        userlink = Userlink.new(:uid=>hash['uid'], :link_id=>link.id, :date=>hash['date'])
        userlink.save!
      else
      end
    end
    sleep(15)
  end
end
