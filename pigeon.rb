%w(yaml gmail mongo_mapper helpers).each { |dependency| require dependency }

def process(part, links) 
  if part.multipart?
    part.part.each do |p|
      process(p, links)
    end
  else
    find_links(part.decoded, links)
  end
end

def do_gmail(user, credentials)
	gmail = Gmail.new(credentials.username, credentials.password) do |gmail|
	  inbox = gmail.inbox
	  inbox.emails(:unread).each do |email|
	    process!(user, email)
	  end
	end
end

User.all().each do |user|
  puts user.inspect
  Stream.where(:uid=>user.uid).all().each do |stream|
    puts stream.inspect
    if stream.type == 'gmail'
      do_gmail(user, stream.credentials)
    end
  end
end
