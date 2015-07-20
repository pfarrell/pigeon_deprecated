class Pigeon < Sinatra::Application
  get '/?' do
    redirect '/index.html'
  end

  get '/redirect' do
    puts params[:url]
    Article.where(Sequel.like(:url, "#{params[:url]}%")).each do |article|
      article.clicks += 1
      article.save
      click = Click.new(article: article)
      click.save
    end
    redirect params[:url]
  end
end
