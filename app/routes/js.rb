class Pigeon < Sinatra::Application
  get "/marklet.js" do
    content_type "application/javascript"
    haml :marklet, :layout=>false, locals: {host: settings.host}
  end

  get "/app.js" do 
    content_type "application/javascript"
    haml :app, :layout=>false, locals: {host: settings.host}
  end

  get "/bookmark/new" do
    content_type "application/javascript"
    enqueue("incoming:links", {:url => params[:url], :title=> params[:title], :date=> DateTime.now}.to_json)
    nil
  end
end