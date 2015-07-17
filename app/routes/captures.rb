class Pigeon < Sinatra::Application
  get "/captures" do
    Capture.to_json(array: Capture.order(Sequel.desc(:id)).limit(100), include: :article, root: :collection)
  end
end
