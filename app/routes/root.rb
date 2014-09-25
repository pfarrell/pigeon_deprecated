class Pigeon < Sinatra::Application
  get "/" do
    haml :index, locals: {sources: Source.all}
  end
end
