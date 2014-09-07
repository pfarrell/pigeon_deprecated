require 'sequel'
require 'logger'

DB = Sequel.connect(
  "mysql2://#{ENV["PIGEON_DB_USER"]}:#{ENV["PIGEON_DB_PASS"]}@#{ENV["PIGEON_DB_HOST"]}/#{ENV["PIGEON_DB_NAME"]}",
  logger: $console)
DB.sql_log_level = :debug
DB.extension(:pagination)

Sequel::Model.plugin :timestamps
Sequel::Model.plugin :json_serializer

require_relative 'models/article'
require_relative 'models/link'
require_relative 'models/source'
require_relative 'models/rss_feed'
