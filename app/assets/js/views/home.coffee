$ ->
  class HomeView extends Backbone.View

    el: $('#app')

    initialize: ->
      @render()

    render: ->
      debugger
      $(@el).html(ich.home())

  homeView = new HomeView
