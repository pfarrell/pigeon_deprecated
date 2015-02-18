App = Ember.Application.create({
   LOG_TRANSITIONS: true,
    LOG_VIEW_LOOKUPS: true,
     LOG_ACTIVE_GENERATION: true
});

App.Router.map(function() {
  this.resource('sources', function() {
    this.resource('articles', { path: ':source_id/articles'});
  });
  this.resource('search', {path: 'search'});
});

App.ApplicationRoute = Ember.Route.extend({
  actions: {
    search: function() {
      this.transitionTo('search');
    }
  }
});

App.IndexController = Ember.ObjectController.extend({
});

App.IndexRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('captures');
  },
  actions: {
    search: function(query) {
      console.log(query);
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

App.SearchRoute = Ember.Route.extend({
  model: function(params) {
    console.log(params);
    return Ember.$.getJSON('search/?q=' + params.search)
  },
  actions: {
    search: function(params) {
      console.log(params);
      
      return Ember.$.getJSON('search/?q=' + params)
    }
  }
});
