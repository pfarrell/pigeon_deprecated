App = Ember.Application.create({});

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
  this.resource('articles');
});

App.ArticlesRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('/source/3/articles');
  }
});

App.SourcesRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('/sources');
  }
});
