require 'rss'

class Pigeon < Sinatra::Application
  get "/sources" do
    haml :sources, locals: {sources: Source.all}
  end

  get "/source/new" do
    haml :source
  end

  get "/source/:id" do
    data = RssFeed[params[:id].to_i]
    respond_to {|wants|
      wants.html { haml :rss_feed, locals: { model: data }}
      wants.json { data.to_json }
    }
  end

  get "/source/:id/current" do
    feed = RssFeed[params[:id]]
    data = feed.articles
    respond_to do |wants|
      wants.html{ haml :articles, locals: { articles: data, feed: feed } }
      wants.json{ data.to_json }
    end
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
