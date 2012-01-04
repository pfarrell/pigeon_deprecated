%w(yaml gmail mongo_mapper helpers).each { |dependency| require dependency }

def do_gmail(user, credentials)
	gmail = Gmail.new(credentials.username, credentials.password)do |gmail|
	  gmail.inbox.emails(:read).each do |email|
	    extract_links(email).each do |key, val|
       if Link.find_by_remote_url(key).nil?
         begin
           save_page(user, key, email)
         rescue
           email.mark(:unread)
         end
        end
      end
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
