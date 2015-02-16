App = Ember.Application.create({
   LOG_TRANSITIONS: true,
    LOG_VIEW_LOOKUPS: true,
     LOG_ACTIVE_GENERATION: true
});

App.Router.map(function() {
  this.resource('sources', function() {
    this.resource('articles', { path: ':source_id/articles'});
  });
});

App.IndexRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('captures');
  }
});

App.SourcesRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('sources');
  }
});

App.ArticlesRoute = Ember.Route.extend({
  model: function(params) {
    return Ember.$.getJSON('sources/' + params.source_id + '/articles');
  },
});
