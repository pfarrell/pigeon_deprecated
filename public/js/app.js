App = Ember.Application.create({
   LOG_TRANSITIONS: true,
    LOG_VIEW_LOOKUPS: true,
     LOG_ACTIVE_GENERATION: true
});

App.Router.map(function() {
  this.resource('sources', function() {
    this.resource('articles', { path: ':source_id/articles'});
  });
  this.resource('search', {path: 'search/:search_term'});
  this.resource('captures', {path: 'captures'});
  this.resource('stats', {path: 'stats'});
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
    this.transitionTo('captures');
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

App.SourcesRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('sources');
  },
  actions: {
    search: function(query) {
      return true;
    }
  } 
});

App.ArticlesRoute = Ember.Route.extend({
  model: function(params) {
    return Ember.$.getJSON('sources/' + params.source_id + '/articles');
  }
});

App.StatsRoute = Ember.Route.extend({
  model: function(params) {
    return Ember.$.getJSON('stats');
  }
});

App.SearchRoute = Ember.Route.extend({
  model: function(params) {
    console.log(params);
    return Ember.$.getJSON('search/?q=' + params.search_term)
  },
  actions: {
    search: function(params) {
      this.transitionTo('search', encodeURIComponent(params));
    }
  }
});
