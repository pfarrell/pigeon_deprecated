%w(yaml gmail mongo_mapper ./helpers).each { |dependency| require dependency }

yml = YAML::load(File.open('config/config.rb'))

gmail = Gmail.new(yml['gmail']['username'], yml['gmail']['password']) do |gmail|
  inbox = gmail.inbox
  inbox.emails(:unread).each do |email|
    process!(email)
  end
end

