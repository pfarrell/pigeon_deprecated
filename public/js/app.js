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

App.Router.map(function() {
  this.resource('sources');
});

App.SourcesRoute = Ember.Route.extend({
  model: function() {
    return sources;
  }
});
