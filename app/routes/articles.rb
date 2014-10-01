class Pigeon < Sinatra::Application
  post "/article/new" do
    link = Link.new
    link.url = params[:url]
    link.save
    respond_to do |wants|
      wants.html { "saved" }
      wants.json { link.to_json }
    end
  end
end
