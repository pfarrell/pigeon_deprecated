class Pigeon < Sinatra::Application
  get "/recents" do
    count = params[:size] || 100
    Article.last(count.to_i).to_json(include: :source)
  end
end
