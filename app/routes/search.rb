class Pigeon < Sinatra::Application
  get '/search' do
    redirect(url_for("/#{params[:q][1..-1]}")) if params[:q] =~ /^\//
  end
end
