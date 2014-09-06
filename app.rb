$: << File.expand_path('../app', __FILE__)
require 'sinatra'
require 'sinatra/json'
require 'sinatra/cookies'
require 'sinatra/url_for'


class Pigeon < Sinatra::Application
  helpers Sinatra::JSON
  helpers Sinatra::Cookies

  enable :sessions
  set :session_secret, ENV["PIGEON_SESSION_SECRET"]
  set :views, Proc.new { File.join(root, "app/views") }
  before do
    response.set_cookie(:pnc, value: SecureRandom.uuid, expires: Time.now + 3600 * 24 * 365 * 10) if request.cookies["pnc"].nil?
  end

end

require 'models'
require 'routes'

