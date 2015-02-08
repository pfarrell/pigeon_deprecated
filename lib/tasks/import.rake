require 'byebug'
namespace :import do
  def import_feed(feed) 
    begin
      feed.articles.each do |article|
        next unless Article.first(title: article.title, source: feed).nil?
        article.source = feed
        article.save
      end
    rescue Exception => ex
      $stderr.puts("error getting #{feed.url}: #{ex.message}")
    end
  end

  task :feed, [:id] do |t, args|
    import_feed(RssFeed[args[:id].to_i])
  end

  task :feeds do  
    RssFeed.all.each{|feed| import_feed(feed) }
  end

  task :list do
    RssFeed.all.each {|feed| print "[#{feed.id}] #{feed.title.strip}\n"}
  end
  
end
