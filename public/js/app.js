App = Ember.Application.create({});

var sources = [{
  "id":114,
  "type":"rss",
  "title":"flak rss",
  "rss_feed_id":null,
  "created_at":"2015-01-20 14:18:42 -0800",
  "updated_at":null,
  "url":"http://www.tedunangst.com/flak/rss",
  "name":null
},{
  "id":115,
  "type":"rss",
  "title":"Grumpy Gamer",
  "rss_feed_id":null,
  "created_at":"2015-01-20 14:18:42 -0800",
  "updated_at":null,
  "url":"http://grumpygamer.com/rss2.0",
  "name":null
},{
  "id":116,
  "type":"rss",
  "title":"Changing Bits",
  "rss_feed_id":null,
  "created_at":"2015-01-20 14:18:42 -0800",
  "updated_at":null,
  "url":"http://blog.mikemccandless.com/feeds/posts/default",
  "name":null
}];

var articles = [ {"id":"1","title":"Obama push to expand Alaskan refuge","url":"http://www.bbc.co.uk/news/science-environment-30985824#sa-ns_mchannel=rss&ns_source=PublicRSS20-sa"}
                ,{"id":"2","title":"MPs: Ban fracking on carbon grounds","url":"http://www.bbc.co.uk/news/science-environment-30955291#sa-ns_mchannel=rss&ns_source=PublicRSS20-sa"}
                ,{"id":"3","title":"Eyes on Pluto for historic encounter","url":"http://www.bbc.co.uk/news/science-environment-30954673#sa-ns_mchannel=rss&ns_source=PublicRSS20-sa"}
                ,{"id":"4","title":"Jellyfish 'can sense ocean currents'","url":"http://www.bbc.co.uk/news/science-environment-30936192#sa-ns_mchannel=rss&ns_source=PublicRSS20-sa"}
                ,{"id":"5","title":"Scientists slow the speed of light","url":"http://www.bbc.co.uk/news/uk-scotland-glasgow-west-30944584#sa-ns_mchannel=rss&ns_source=PublicRSS20-sa"}
                ,{"id":"6","title":"Comet shows off its 'goosebumps'","url":"http://www.bbc.co.uk/news/science-environment-30931445#sa-ns_mchannel=rss&ns_source=PublicRSS20-sa"}
                ,{"id":"7","title":"Ebola vaccine 'shipped to Liberia'","url":"http://www.bbc.co.uk/news/health-30943377#sa-ns_mchannel=rss&ns_source=PublicRSS20-sa"}
                ,{"id":"8","title":"New record for SA rhino poaching","url":"http://www.bbc.co.uk/news/science-environment-30934383#sa-ns_mchannel=rss&ns_source=PublicRSS20-sa"}
                ,{"id":"9","title":"Satellite system targets 'dark fish'","url":"http://www.bbc.co.uk/news/science-environment-30929047#sa-ns_mchannel=rss&ns_source=PublicRSS20-sa"}
                ,{"id":"10","title":"Meteorite is 'hard drive' from space","url":"http://www.bbc.co.uk/news/science-environment-30916692#sa-ns_mchannel=rss&ns_source=PublicRSS20-sa"}]


App.Router.map(function() {
  this.resource('sources');
  this.resource('articles');
  this.resource('article', { path: "/article/:article_id" });
});

App.ArticlesRoute = Ember.Route.extend({
  model: function() {
    return articles;
  }
});

App.SourcesRoute = Ember.Route.extend({
  model: function() {
    return sources;
  }
});

App.ArticleRoute = Ember.Route.extend({
  model: function(params) {
    return articles.findBy('id', params.article_id);
  }
});
