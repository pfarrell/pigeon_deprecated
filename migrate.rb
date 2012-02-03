require './helpers'

user = User.first
Link.all.each do |link|
  userlink = Userlink.new(:uid=>user.uid, :linkid=>link.id)
  userlink.save
end
