%w(yaml gmail mongo_mapper redis ./helpers).each { |dependency| require dependency }

def do_gmail(redis, user, credentials)
	gmail = Gmail.new(credentials.username, credentials.password)do |gmail|
	  gmail.inbox.emails(:unread).each do |email|
	    extract_links(email).each do |key, val|
       if Link.find_by_remote_url(key).nil?
         begin
           puts 'enqueuing'
           enqueue_link(redis, user, key, email.subject, email.date)
         rescue => e
           puts e.message
           email.mark(:unread)
         end
        end
      end
	  end
	end

  while(redis.llen('incoming:links') > 0)
    hash = JSON.parse(redis.lpop('incoming:links'))

    if !Link.find(:uid=>hash['uid'], :remote_url=>hash['remote_url'])
      link = Link.new(:uid=>hash['uid'], :title=>hash['title'], :date=>hash['date'], :downloaded=>false, :processed=>false, :remote_url=>hash['remote_url'])
      link.save!
    end

    link = get_page!(link)

    link = get_page_contents!(link)
  end
end

redis = Redis.new

User.all().each do |user|
  Streams.where(:uid=>user.uid).all().each do |stream|
    if stream.type == 'gmail'
      do_gmail(redis, user, stream.credentials)
    end
  end
end
