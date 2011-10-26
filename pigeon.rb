%w(yaml gmail helpers).each { |dependency| require dependency }

yml = YAML::load(File.open('config/config.rb'))

puts yml['gmail']['username']
puts yml['gmail']['password']

gmail = Gmail.new(yml['gmail']['username'], yml['gmail']['password']) do |gmail|
  inbox = gmail.inbox
  inbox.emails(:unread).each do |email|
    puts email.subject
    process!(email)
  end
end

