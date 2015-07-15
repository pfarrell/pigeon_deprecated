require 'rss'

class Pigeon < Sinatra::Application
  get "/rssFeeds" do
    RssFeed.to_json(except: [:created_at, :updated_at], array: RssFeed.sort_by{|x| x.title.strip}, root: "rssFeeds")
  end

  get "/sources/:id" do
    RssFeed[params[:id].to_i].to_json 
  end

  get "/sources/:id/articles" do
    feed = RssFeed[params[:id]]
    Article.where(source: feed).order(Sequel.desc(:id)).limit(100).to_json
  end

end
