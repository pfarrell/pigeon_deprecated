class Pigeon < Sinatra::Application
  get "/stats" do
    DB.fetch("SELECT s.id as source_id, s.title, count(*) from sources s join articles a on a.source_id = s.id group by s.id order by count(*) desc").all.to_json
  end
end
