class Pigeon < Sinatra::Application
  get "/stats" do
    stats=DB.fetch("SELECT s.id as source_id, s.title, count(*) from sources s join articles a on a.source_id = s.id group by s.id order by count(*) desc").all
    stats.insert(0, {source_id: -1, title: "Total Articles", count: Article.count})
    stats.to_json
  end
end
