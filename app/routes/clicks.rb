class Pigeon < Sinatra::Application
  get '/clicks/?' do
    Click.to_json(array: Click.order(Sequel.desc(:id)).limit(100),
                    root: :collection,
                    include: :article
                    )
  end
end
