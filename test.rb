require './helpers'

Usercontent.all.each do |uc|
  if uc.content.nil?
    puts 'found nil';
  end
end


