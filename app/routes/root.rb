class Pigeon < Sinatra::Application
  get '/?' do
    redirect '/index.html'
  end
end
