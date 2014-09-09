require 'sequel'
require 'logger'

DB = Sequel.connect(
  "mysql2://#{ENV["PIGEON_DB_USER"]}:#{ENV["PIGEON_DB_PASS"]}@#{ENV["PIGEON_DB_HOST"]}/#{ENV["PIGEON_DB_NAME"]}",
  logger: $console)
DB.loggers << Logger.new($stdout) if ENV["PIGEON_DB_DEBUG"] == "true"
DB.extension(:pagination)

Sequel::Model.plugin :timestamps
Sequel::Model.plugin :json_serializer

require_relative 'models/article'
require_relative 'models/link'
require_relative 'models/source'
require_relative 'models/rss_feed'
