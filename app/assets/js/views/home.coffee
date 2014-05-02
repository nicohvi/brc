$ ->
  class HomeView extends Backbone.View

    el: $('#home')

    initialize: ->
      @render()

    events: {
      'click .login': 'openLoginForm'
    }

    openLoginForm: (event) ->

    render: ->
      debugger
      $(@el).html ich.home()

  @HomeView = HomeView
