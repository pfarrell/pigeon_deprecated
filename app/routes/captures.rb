class Pigeon < Sinatra::Application
  get "/captures" do
    Capture.order(Sequel.desc(:id)).limit(100).to_json(include: :article)
  end
end
