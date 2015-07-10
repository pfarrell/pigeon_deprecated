class Pigeon < Sinatra::Application
  get '/?' do
    redirect '/index.html'
  end

  get '/redirect' do
    redirect params[:dest]
  end
end
