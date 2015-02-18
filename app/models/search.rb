class Search
  def lookup(query)
    Article.where(Sequel.ilike(:title, "%#{query}%"))
  end
end
