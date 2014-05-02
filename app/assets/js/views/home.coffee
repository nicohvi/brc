$ =>

  class HomeView extends Backbone.View

    initialize: ->
      @el = $('#home')
      @render()

    events: {
      'click .login': 'openLoginForm'
    }

    openLoginForm: (event) ->

    render: ->
      debugger
      $(@el).html ich.homeTmp()

  @HomeView = HomeView
