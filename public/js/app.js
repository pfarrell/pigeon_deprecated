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
  this.resource('sources');
  this.resource('source', {path: '/source/:source_id'});
  this.resource('articles', { path: '/articles/:source_id'});
});

App.SourcesRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('/sources');
  }
});

App.SourceRoute = Ember.Route.extend({
  model: function(params) {
    return Ember.$.getJSON('/source/' + params.source_id);
  }
});

App.ArticlesRoute = Ember.Route.extend({
  model: function(params) {
    return Ember.$.getJSON('/source/' + params.source_id + '/articles');
  },
  setupController: function(controller, model) {
    var articles_model = Ember.$.getJSON('/source/' + model.id + '/articles');
    controller.set("content", articles_model);
  }
});
