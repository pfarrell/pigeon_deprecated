App = Ember.Application.create({
 LOG_TRANSITIONS: true,
 LOG_VIEW_LOOKUPS: true,
 LOG_ACTIVE_GENERATION: true
});

App.ApplicationRoute= Ember.Route.extend({
  setupController: function(controller) {
    controller.set('title', "Hello world!");
  }
});

App.ApplicationController = Ember.Controller.extend({
    title: 'My First Example'
});

App.Router.map(function() {
  this.resource('sources', function() {
    this.resource('articles', { path: '/:source_id/articles'});
  });
});

App.SourcesRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('/sources');
  }
});

App.ArticlesRoute = Ember.Route.extend({
  model: function(params) {
    return Ember.$.getJSON('/source/' + params.source_id + '/articles');
  },
});
