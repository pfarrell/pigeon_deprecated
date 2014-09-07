require 'rss'

class Pigeon < Sinatra::Application
  get "/sources" do
    haml :sources, locals: {sources: Source.all}
  end

  get "/source/new" do
    haml :source
  end

  get "/source/:id" do
    haml :rss_feed, locals: { model: RssFeed[params[:id].to_i] }
  end

  get "/source/:id/current" do
    haml :articles, locals: { articles: RssFeed[params[:id].to_i].articles }
  end

  post "/source/new" do
    feed = RssFeed.new
    feed.title = params[:title]
    feed.url  = params[:url]
    feed.type = params[:type]
    feed.save
    redirect url_for("/sources")
  end

  post "/source/:id" do
    feed = RssFeed[params[:id].to_i]
    feed.title= params[:title]
    feed.url = params[:url]
    feed.save_changes
    haml :rss_feed, locals: {model: feed}
  end

end
