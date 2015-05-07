require './app'

puts ARGV[0]
puts Cleanup.new.clean(ARGV[0])

