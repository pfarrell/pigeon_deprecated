class RssFeed < Sequel::Model
  one_to_one :source
end
