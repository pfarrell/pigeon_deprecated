require 'sequel'
require 'logger'


$console = Logger.new STDOUT
DB = Sequel.connect(ENV['PIGEON_DB'] || 'postgres://localhost/pigeon',logger: $console)

DB.sql_log_level = :debug
DB.extension(:pagination)

Sequel::Model.plugin :timestamps
Sequel::Model.plugin :json_serializer

require_relative 'models/article'
require_relative 'models/link'
require_relative 'models/source'
require_relative 'models/rss_feed'
