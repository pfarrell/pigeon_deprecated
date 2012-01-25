%w(yaml gmail mongo_mapper ./helpers).each { |dependency| require dependency }

def do_gmail(user, credentials)
	gmail = Gmail.new(credentials.username, credentials.password)do |gmail|
	  gmail.inbox.emails(:unread).each do |email|
	    extract_links(email).each do |key, val|
       if Link.find_by_remote_url(key).nil?
         begin
           new_link(user, key, email.subject, email.date)
         rescue
           email.mark(:unread)
         end
        end
      end
	  end
	end

  Link.where(:downloaded=>false).each do |link|
    save_link(link)
  end

  Link.where(:processed=>false, :errored=>nil).each do |link|
    get_page_contents(link)
  end
end


User.all().each do |user|
  Streams.where(:uid=>user.uid).all().each do |stream|
    if stream.type == 'gmail'
      do_gmail(user, stream.credentials)
    end
  end
end
