class Source < Sequel::Model
  many_to_one :articles
  one_to_many :rss_feeds
end
