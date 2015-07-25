require 'htmlentities'
class Pigeon < Sinatra::Application
  get "/captures" do
    Capture.to_json(array: Capture.order(Sequel.desc(:id)).limit(100), include: :article, root: :collection)
  end

  post "/captures" do
    content_type "application/javascript"
    obj = JSON.parse(request.body.read)
    enqueue("incoming:links", {:url => URI.decode(obj["capture"]["url"]), :date=> DateTime.now}.to_json)
    return {}.to_json
  end
end
