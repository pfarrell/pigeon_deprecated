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
  @prev = 0
  @next = ''
end

get '/' do 
  redirect '/1'
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :style
end

post '/search' do
  if params['search'] == ''
    redirect '/'
  else
    @links = search_links(params['search'])
  end
  haml :index
end

get '/:page' do
  page = params[:page]
  @links = get_links(page.to_i, @limit)
  haml :index
end

