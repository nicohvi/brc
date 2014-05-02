$ =>
  class AppView extends Backbone.View

    el: $('#app')

    initialize: ->
      @render()
      @home = new HomeView()

    render: ->
      $(@el).html ich.appTmp()

  @AppView = AppView
