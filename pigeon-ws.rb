%w(yaml sinatra haml sass helpers).each { |dependency| require dependency }

set :port, 4567
set :haml =>{:format => :html5}

enable :sessions
enable :methodoverride

before do
  @style = 'style.css'
  @time = Time.now
  @nav = :nav
  @title = 'Pigeon'
end

get '/' do 
  @links = get_links()
  haml :index
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :style
end
