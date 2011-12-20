%w(yaml omniauth omniauth-facebook omniauth-twitter sinatra haml sass helpers).each { |dependency| require dependency }
gem 'emk-sinatra-url-for'
require 'sinatra/url_for'

set :port, 4569
set :haml =>{:format => :html5}

enable :sessions
enable :methodoverride

$yml = YAML.load_file 'config/config.yml'

use Rack::Session::Cookie
use OmniAuth::Builder do
puts $yml["twitter"]["api_key"]
puts $yml["twitter"]["secret_key"]
    provider :facebook, $yml["facebook"]["app_id"], $yml["facebook"]["app_secret"], {:client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}
    provider :twitter, $yml["twitter"]["api_key"], $yml["twitter"]["secret_key"]
end

helpers do
  def current_user
    @current_user ||= User.find_by_uid(session[:user_id]) if session[:user_id]
  end

  def protected(name)
    if @current_user.nil? || @current_user.username != name
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
end

get '/' do 
  if @current_user.nil?
    haml :index
  elsif @current_user.username.nil?
    redirect url_for('/user')
  else
    redirect url_for('/u/' + @current_user.username + '/0')
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
  if @current_user.nil?
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
    end
  else
    user = @current_user
  end

  stream = Stream.find_by_token(auth["credentials"]["token"])
  if stream.nil?
    stream = Stream.new(:uid=>user.uid, :name=>auth["provider"], :type=>auth["provider"], :token=>auth["credentials"]["token"])
    stream.save!
  end

  redirect url_for('/u/' + user.username)
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
  @streams = Stream.where(:uid=>@current_user.uid).all
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

get '/u/:user/stream' do
  protected(params[:user])
  haml :stream
end

get '/u/:user/stream/:name' do
  protected(params[:user])
  @stream = Stream.find_by_name(params[:name])
  haml :stream
end

post '/u/:user/stream' do
  protected(params[:user])
  if params[:streamid].nil?
    credentials = Credentials.new(:username=>params["username"], :password=>params["password"]) 
    credentials.save
    stream = Stream.new(:uid=>@current_user.uid, :name=>params["name"], :type=>params["type"], :credentials=>credentials)
    stream.save
  else
    stream = Stream.find_by_id(params[:streamid])
    stream.name = params[:name]
    stream.type = params[:type]
    stream.credentials.username = params[:username]
    stream.credentials.password = params[:password]
  end
  redirect url_for('/u/' + @current_user.username)
end

post '/u/:user/search' do
  if params['search'] == ''
    redirect url_for('/u/' + params[:user] + '/0')
  else
    @links = search_links(get_user(params[:user]), params['search'])
  end
  @search = params['search']
  haml :page
end

get '/u/:user/:page/?' do
  @links = get_links(get_user(params[:user]), params[:page].to_i, @limit)
  haml :page
end

