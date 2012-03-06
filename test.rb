require './helpers'

Streams.all.each do |stream|
  puts stream.id.to_s + ' ' + Link.where(:stream_id=>stream.id.to_s).count.to_s
end
