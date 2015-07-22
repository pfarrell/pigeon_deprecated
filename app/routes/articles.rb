class Pigeon < Sinatra::Application
  get "/recents" do
    count = params[:size] || 100
    Article.to_json(include: :source, array: Article.last(count.to_i), root: "recents")
  end

  get "/randoms" do
    count = params[:size] || 100
    Article.to_json(include: :source, array: Article.exclude(title: nil).order(Sequel.lit('RANDOM()')).first(count), root: "randoms")
  end

end
