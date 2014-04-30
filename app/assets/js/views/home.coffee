$ ->
  class HomeView extends Backbone.View

    el: $('#app')

    initialize: ->
      @render()

    render: ->
      $(@el).html(ich.home())

  homeView = new HomeView
