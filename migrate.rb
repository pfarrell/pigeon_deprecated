require './helpers'

user = User.first
Link.all.each do |link|
  userlink = Userlink.new(:uid=>user.uid, :link_id=>link.id)
  userlink.save
end
