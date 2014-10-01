class Pigeon < Sinatra::Application
  get "/" do
    respond_to do |wants|
      wants.html { haml :index, locals: {sources: Source.all} }
      wants.json { Source.all.to_json }
    end
  end
end
