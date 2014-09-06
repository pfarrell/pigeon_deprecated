class Article < Sequel::Model
  many_to_one :source
end
