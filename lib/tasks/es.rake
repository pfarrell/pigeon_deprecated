require 'json'
require 'htmlentities'


namespace :es do
  task :process do
    bg = Background.new
    json = background.resurrect("incoming:pages")
      
  end
end
