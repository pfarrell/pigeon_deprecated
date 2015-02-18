class Pigeon < Sinatra::Application
  get '/search/?' do
    Article.where(Sequel.ilike(:title, "%#{params[:q]}%")).to_json
  end
end
