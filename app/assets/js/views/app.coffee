$ ->
  class AppView extends Backbone.View

  el: $('#app')

  initialize: ->
    @home = new HomeView()

  render: ->
    $(@el).html ich.app()

@AppView = AppView
