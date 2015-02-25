class Pigeon < Sinatra::Application
  get "/stats" do
    DB[:articles].group_and_count(:source_id).order(Sequel.desc(:count)).all.to_json
  end
end
