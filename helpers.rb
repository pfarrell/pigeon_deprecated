%w(mail uri).each { |dependency| require dependency }

def String.random_alphanumeric(size=16)
  s = ""
  size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
  s
end

def send_email(from, from_alias, to, to_alias, subject, message)
  Pony.mail(
    :to => to,
    :via => :smtp, 
    :via_options => {
      :port => '587',
      :address => 'smtp.gmail.com',
      :enable_starttls_auto => true,
      :user_name => $yml["smtp"]["user"],
      :password => $yml["smtp"]["password"],
      :authentication => :plain,
      :domain => 'HELO',
    },
    :subject => subject, 
    :body => message)
end

def mkdir!(directory) 
  if !FileTest::directory?(directory)
    Dir::mkdir(directory)
  end
end

def process!(email)
  begin
    links = {}
    email.body.parts.each do |part|
      find_links!(part.decoded, links)
    end
    links.each do |key, val|
      puts key
      save_page(key)
    end
  ensure
    email.mark(:unread)
  end
end

def find_links!(part, links)
  arr = part.scan(/http[s]?:\/\/[a-zA-Z0-9\/\.\_-]*/)
  arr.each do |entry|
    if /www\.w3\.org/.match(entry).nil? \
      and /schemas\.microsoft/.match(entry).nil?
      links[entry] = entry
    end
  end
end

def save_page(link) 
  mkdir!("sites")
  dir = String.random_alphanumeric()
  uri = URI.parse(link)
  file = link.split('/').last
  if link.match(/\/$/)
    file = 'index.html'
  end
  if !file.match(/\.html$/)  
    file = file + '.html'
  end
  system("wget -qnd -pHEKk --random-wait -P sites/" + dir + " " + link)
  File.open("sites/index.html", 'a') {|f| f.write("<div><a href='" + dir + '/' + file + "'>" + link + "</a></div>")}
end
