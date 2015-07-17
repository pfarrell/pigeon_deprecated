class Pigeon < Sinatra::Application
  get "/recents" do
    count = params[:size] || 100
    Article.to_json(include: :source, array: Article.last(count.to_i), root: "recents")
  end
end
