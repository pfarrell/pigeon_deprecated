class Pigeon < Sinatra::Application
  get '/searches/?' do
    search=URI.decode(params[:q])
    Article.to_json(array: Article.where(Sequel.ilike(:title, "%#{search}%")).order(Sequel.desc(:id)).limit(100),
                    root: "searches")
  end
end
