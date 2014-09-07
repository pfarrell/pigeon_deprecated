class Article < Sequel::Model
  many_to_one :source
  many_to_many :links

  def content
    links.select{|link| link.type == "content"}
  end

  def comments
    links.select{|link| link.type == "comments"}
  end
end
