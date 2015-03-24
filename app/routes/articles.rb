class Pigeon < Sinatra::Application
  get "/articles/recent" do
    count = params[:size] || 100
    Article.last(count).to_json
  end
end
