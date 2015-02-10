class Pigeon < Sinatra::Application
  get "/marklet.js" do
    content_type "application/javascript"
    haml :marklet, :layout=>false, locals: {host: settings.host}
  end

  get "/bookmark/new" do
    enqueue("incoming:links", {url => params[:url]}.to_json)
    nil
  end
end
