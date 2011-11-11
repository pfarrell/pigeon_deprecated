%w(yaml sinatra haml sass helpers).each { |dependency| require dependency }

set :port, 4569
set :haml =>{:format => :html5}

enable :sessions
enable :methodoverride

before do
  @style = 'style.css'
  @time = Time.now
  @nav = :nav
  @title = 'Pigeon'
  @limit = 5
end

get '/' do 
  redirect '/1'
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :style
end

get '/:page' do
  page = params[:page]
  @links = get_links(page.to_i, @limit)
  haml :index
end

