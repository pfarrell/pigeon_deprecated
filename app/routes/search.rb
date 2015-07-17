class Pigeon < Sinatra::Application
  get '/searches/?' do
    Article.to_json(array: Article.where(Sequel.ilike(:title, "%#{params[:q]}%")).order(Sequel.desc(:id)).limit(100),
                    root: "searches")
  end
end
