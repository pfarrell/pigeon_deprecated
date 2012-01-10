%w(./helpers).each { |dependency| require dependency }

Link.all.each do |link|
  link.downloaded = true
  link.save
end
