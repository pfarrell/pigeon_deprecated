%w(yaml omniauth omniauth-facebook sinatra haml sass ./helpers json redis).each { |dependency| require dependency }
gem 'emk-sinatra-url-for'
require 'sinatra/url_for'

set :port, 4567
set :haml =>{:format => :html5}

enable :sessions
enable :methodoverride

$yml = YAML.load_file 'config/config.yml'
$redis = Redis.new

use Rack::Session::Cookie
use OmniAuth::Builder do
    provider :facebook, $yml["facebook"]["app_id"], $yml["facebook"]["app_secret"], {:client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}
end

helpers do
  def current_user
    @current_user ||= User.find_by_uid(session[:user_id]) if session[:user_id]
  end

  def protected(name)
    if current_user.nil? || current_user.username != name
      @error = "Security violation"
      redirect url_for('/')
    end
  end
end

before do
  request.env['PATH_INFO'] = '/' if request.env['PATH_INFO'].empty?
  if !@error.nil?
    @error = ''
  end
  @style = 'style.css'
  @time = Time.now
  @nav = :nav
  @authed = current_user ? :authed : :unauthed
  @title = 'Pigeon'
  @limit = 5
  @prev = -1
  @next = ''
  @host = $yml["host"]
  @types = %w(Gmail Twitter Facebook RSS)
end

get '/' do 
  if @current_user.nil?
    haml :index
  elsif @current_user.username.nil?
    redirect url_for('/user')
  else
   # redirect url_for('/u/' + @current_user.username + '/0')
   haml :index
  end
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :style
end

["/sign_in/?", "/signin/?", "/log_in/?", "/login/?", "/sign_up/?", "/signup/?"].each do |path|
end

# either /log_out, /logout, /sign_out, or /signout will end the session and log the user out
["/sign_out/?", "/signout/?", "/log_out/?", "/logout/?"].each do |path|
  get path do
    @authed = :unauthed
    session[:user_id] = nil
    redirect url_for('/')
  end
end

get '/auth/:provider/callback' do
  auth = request.env["omniauth.auth"]
  user = User.find_by_uid(auth["uid"])
  if user.nil?
    user = User.new( :uid => auth["uid"], 
      :nickname => auth["info"]["nickname"], 
      :name => auth["provider"])
      user.save!
    session[:user_id] = user.uid
    redirect url_for('/u/user')
  else
    session[:user_id] = user.uid
    redirect url_for('/u/' + user.username)
  end
end

get '/auth/failure' do
    redirect url_for('/u/')
end

get 'search' do
  redirect url_for('/')
end

post '/search' do
  if params['search'] == ''
    redirect url_for('/')
  else
    @links = search_all_links(params['search'])
  end
  @user = ''
  @search = params['search']
  haml :page
end

get '/u/user/?' do
  haml :new_account
end

post '/u/user/?' do
  @current_user.username = params["username"]
  @current_user.save
  redirect url_for('/u/' + @current_user.username)
end

get '/u/:user' do
  protected(params[:user])
  @streams = get_streams(@current_user)
  #@streams = Streams.where(:uid=>@current_user.uid).all
  @stats = get_stats(@current_user)
  puts @stats.inspect
  haml :account
end

get '/u/:user/' do
  redirect url_for('/u/' + params[:user] + '/0')
end

post '/u/:user/?' do
  protected(params[:user])
  @current_user.username = params["username"]
  @current_user.save
  redirect url_for('/u/' + @current_user.username)
end

post '/u/:user/remove' do
  content_type :json
  protected(params[:user])
  userlink = Userlink.find_by_id(params[:obj_id])
  userlink.deleted = params[:mode] == 'normal' ? true : nil
  userlink.save!
end

post '/u/:user/download' do
  content_type :json
  protected(params[:user])
  puts params.inspect
  link = Link.find_by_id(params[:obj_id])
  enqueue_link(Redis.new, nil, @current_user, link.remote_url, link.title, Time.new)
end

get '/u/:user/marklet.js' do
  @user=params[:user]
  haml :marklet, :layout=>false
end

get '/u/:user/link' do
  # need validation of bookmarklet post
  user = get_user(params[:user])
  enqueue_link($redis, nil, user, params[:url], params[:title], Time.new)
end

get '/u/:user/stream' do
  protected(params[:user])
  @url = 'none'
  @cred = 'block`'
  haml :stream
end

get '/u/:user/stream/v/:name/:page' do
  @links = get_stream_links(params[:name], params[:page].to_i, @limit)
  @user = params[:user]
  haml :links
end

get '/u/:user/stream/:name' do
  protected(params[:user])
  @stream = Streams.find_by_name(params[:name])
  @url = @stream.type == 'rss' ? 'block': 'none'
  @cred = @stream.type == 'rss' ? 'none': 'block'
  haml :stream
end

post '/u/:user/stream' do
  protected(params[:user])
  if params[:streamid].nil?
    if params[:type].downcase == 'rss'
      rss = get_rss(params[:url])
      stream = Streams.new(:uid=>@current_user.uid, :name=>rss.feed.title, :type=>params["type"], :url=>params["url"])
    else
      stream = Streams.new(:uid=>@current_user.uid, :name=>params["name"], :type=>params["type"], :username=>params["username"], :password=>params["password"])
    end
    stream.save
  else
    stream = Streams.find_by_id(params[:streamid])
    stream.name = params[:name]
    stream.type = params[:type]
    stream.username = params[:username]
    stream.password = params[:password]
    stream.url = params[:url]
    stream.save
  end
  redirect url_for('/u/' + @current_user.username)
end

get '/u/:user/deleted/:page' do
  protected(params[:user])
  @links = get_deleted_links(get_user(params[:user]), params[:page].to_i, @limit)
  @user = params[:user]
  @mode='deleted'
  haml :page
end

post '/u/:user/raw/search' do
  protected(params[:user])
  if params['search'] == ''
    redirect url_for('/u/' + params[:user] + '/0')
  else
    @links = search_raw_links(params['search'])
  end
  @user = params[:user]
  @search = params['search']
  haml :links
end

get '/u/:user/raw/:page' do
  protected(params[:user])
  @links = get_raw_links(get_user(params[:user]), params[:page].to_i, @limit)
  @user = params[:user]
  haml :links
end

get '/u/:user/rss' do
  content_type 'application/rss+xml'
  @links = get_links(get_user(params[:user]), 0, 25)
  haml(:rss, :format => :xhtml, :escape_html => true, :layout => false)
end

post '/u/:user/search' do
  if params['search'] == ''
    redirect url_for('/u/' + params[:user] + '/0')
  else
    @links = search_user_links(get_user(params[:user]), params['search'])
  end
  @user = params[:user]
  @search = params['search']
  haml :page
end

get '/u/:user/:page/?' do
  @links = get_links(get_user(params[:user]), params[:page].to_i, @limit)
  @user = params[:user]
  @mode='normal'
  haml :page
end

