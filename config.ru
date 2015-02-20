$: << File.expand_path('../', __FILE__)

require 'app'

set :environment, ENV['RACK_ENV'].to_sym || 'development'
disable :run, :reload
use Rack::Deflater

run Pigeon.new
