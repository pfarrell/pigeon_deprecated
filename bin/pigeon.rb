%w(yaml gmail mongo_mapper redis feedzirra open-uri ./helpers).each { |dependency| require dependency }

def do_gmail(redis, user, stream)
  puts "#{Time.now.to_s}: do gmail"
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
  puts "#{Time.now.to_s}: #{stream.url}"
  begin
    rss = get_rss(stream.url)
    rss.entries.each do |entry|
      enqueue_link(redis, stream, nil, entry.url, entry.title, Time.new)
    end
    puts "#{Time.now.to_s}: #{stream.url} added #{rss.entries.size}"
  rescue => e
    puts stream.url + ': ' + e.message 
  end
end

def running?(file_name)
  retval = true
  if !File.exists?(file_name)
    generate_pid(file_name, $$)
    retval = false
  else
    file_pid = open(file_name).gets
    begin
      Process.kill 0, file_pid.to_i
    rescue
      generate_pid(file_name, $$)
      retval = false
    end
  end
  retval
end

def generate_pid(file_name, process_id)
  File.open(file_name, 'w+') {|f| f.write($$) }
end

puts "#{Time.now.to_s}: Starting"
if !running?("/tmp/pigeon.pid")
  puts "#{Time.now.to_s}: pigeon free to fly"
  iter = -1
  redis = Redis.new

  while(true)
    iter = iter + 1
    puts "#{Time.now.to_s}: starting up"
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
        puts "#{Time.now.to_s}: creating link #{hash['remote_url']}"
        link = Link.new(:title=>hash['title'], :date=>hash['date'], :stream_id=>hash['stream_id'], :downloaded=>false, :processed=>false, :remote_url=>hash['remote_url'])
        link.save!
        link = get_page_contents!(link)
        link.save!
      else
        puts "#{Time.now.to_s}: skipping link #{link.remote_url}"
      end
      
      if !link.nil? && !hash['uid'].nil? 
        if !link.downloaded
          puts "#{Time.now.to_s}: downloading #{link.remote_url}"
          link = get_page!(link)
          #puts 'downloaded: ' + link.inspect
        end
        userlink = Userlink.new(:uid=>hash['uid'], :link_id=>link.id, :date=>hash['date'])
        userlink.save!
      else
      end
    end
    #sleep(15)
  end
else
  puts "#{Time.now.to_s}: pigeon was caged"
end
