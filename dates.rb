require './helpers'

Userlink.all.each do |ul|
puts ul.date.to_s + ': ' + ul.created_at.to_s
end
