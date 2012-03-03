require './helpers'

Userlink.sort(:created_at.desc).each do |ul|
  link = Link.find(ul.link_id)
  user = User.find_by_uid(ul.uid)
  exists = Usercontent.where(:uid=>user.uid, :link_id=>link.id).count
  if !link.nil? && !user.nil? && exists == 0
    usercontent = Usercontent.new(:uid=>user.uid, :link_id=>link.id, :title=>link.title, :content=>link.content, :date=>link.created_at)
    usercontent.save!
    puts 'saved new usercontent: ' + usercontent.id
  end
end

