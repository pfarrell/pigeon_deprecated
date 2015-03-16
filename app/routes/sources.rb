require 'rss'

class Pigeon < Sinatra::Application
  get "/sources" do
    RssFeed.sort_by{|x| x.title.strip}.to_json
  end

  get "/sources/new" do
    haml :source
  end

  get "/sources/:id" do
    RssFeed[params[:id].to_i].to_json 
  end

  get "/sources/:id/articles" do
    feed = RssFeed[params[:id]]
    Article.where(source: feed).order(Sequel.desc(:id)).limit(100).to_json
  end

  post "/sources/new" do
    feed = RssFeed.new(params)
    feed.save
    url_for("/sources")
  end

  post "/sources/:id" do
    feed = RssFeed[params[:id].to_i]
    feed.title= params[:title]
    feed.url = params[:url]
    feed.save_changes
    haml :rss_feed, locals: {model: feed}
  end

end
