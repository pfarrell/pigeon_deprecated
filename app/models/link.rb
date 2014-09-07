class Link < Sequel::Model
  many_to_many :articles
end
