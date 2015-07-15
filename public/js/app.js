App = Ember.Application.create({
  LOG_TRANSITIONS: true,
  LOG_VIEW_LOOKUPS: true,
  LOG_ACTIVE_GENERATION: true
});

var attr = DS.attr;

App.RssFeed = DS.Model.extend({
  type: attr(),
  title: attr(),
  url: attr()
});

Ember.Handlebars.helper('date', function(value, options) {
  if(value==null) {
    return "";
  }else{
    return new Ember.Handlebars.SafeString('<span>' + moment(value.replace(" ", "T").replace(" ", "")).fromNow() + '</span>');
  }
});

App.Router.map(function() {
  this.resource('rssFeeds', {path: 'rssFeeds'});
  this.resource('articles', { path: 'sources/:source_id/articles'});
  this.resource('search', {path: 'search/:search_term'});
  this.resource('captures', {path: 'captures'});
  this.resource('stats', {path: 'stats'});
  this.resource('recent', {path: 'recent'});
});

App.ApplicationRoute = Ember.Route.extend({
  actions: {
    search: function(params) {
      this.transitionTo('search', encodeURIComponent(params));
    }
  }
});

App.IndexRoute = Ember.Route.extend({
  beforeModel: function() {
    this.transitionTo('recent');
  }
});

App.CapturesRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('captures');
  },
  actions: {
    search: function(query) {
      return true;
    }
  }
});

App.RecentRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('articles/recent');
  },
  actions: {
    search: function(query) {
      return true;
    }
  }
});

App.RssFeedsRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.findAll('rssFeed');
    //return Ember.$.getJSON('rssFeeds');
  },
  actions: {
    search: function(query) {
      return true;
    }
  } 
});

App.ArticlesRoute = Ember.Route.extend({
  model: function(params) {
    this.store.find('source', 1);
    //return Ember.$.getJSON('sources/' + params.source_id + '/articles');
  }
});

App.StatsRoute = Ember.Route.extend({
  model: function(params) {
    return Ember.$.getJSON('stats');
  }
});

App.SearchRoute = Ember.Route.extend({
  model: function(params) {
    return Ember.$.getJSON('search/?q=' + params.search_term)
  },
  actions: {
    search: function(params) {
      this.transitionTo('search', encodeURIComponent(params));
    }
  }
});
