class Pigeon < Sinatra::Application
  get "/captures" do
    Capture.order(Sequel.desc(:id)).limit(50).to_json
  end
end
