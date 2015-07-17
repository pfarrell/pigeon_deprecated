class Pigeon < Sinatra::Application
  get '/?' do
    redirect '/index.html'
  end

  get '/redirect' do
    puts params[:url]
    Article.where(url: params[:url]).each do |article|
      article.clicks += 1
      article.save
    end
    redirect params[:url]
  end
end
