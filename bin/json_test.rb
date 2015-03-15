require './app'
require 'json'

a = Article.new
a.meta={hello: "pat"}.to_json
a.save

puts a.id

a_new = Article[a.id]

puts a_new.meta["hello"]

