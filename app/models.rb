require 'sequel'
require 'logger'


$console = ENV['RACK_ENV'] == 'development' ? Logger.new(STDOUT) : nil
DB = Sequel.connect(ENV['PIGEON_DB'] || 'postgres://localhost/pigeon',logger: $console)

DB.sql_log_level = :debug
DB.extension(:pagination)
DB.extension(:pg_array, :pg_json)
DB.extension(:connection_validator)

Sequel::Model.plugin :timestamps
Sequel::Model.plugin :json_serializer

require_relative 'models/article'
require_relative 'models/link'
require_relative 'models/source'
require_relative 'models/rss_feed'
require_relative 'models/capture'
require_relative 'models/search'
require_relative 'models/elastic_search'
require_relative 'models/click'
