class Pigeon < Sinatra::Application
  post "/article/new" do
    link = Link.new
    link.url = params[:url]
    link.save
    "saved"
  end
end
