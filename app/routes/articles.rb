class Pigeon < Sinatra::Application
  get "/articles/recent" do
    count = params[:size].to_i || 100
    Article.last(count).to_json(include: :source)
  end
end
