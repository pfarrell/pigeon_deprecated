class Pigeon < Sinatra::Application
  get '/search/?' do
    Article.where(Sequel.ilike(:title, "%#{params[:q]}%")).order(Sequel.desc(:id)).limit(50).to_json
  end
end
