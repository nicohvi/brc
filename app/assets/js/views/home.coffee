$ =>

  class HomeView extends Backbone.View

    initialize: ->
      @setElement('#home')
      @render()

    events: {
      'click .login': 'openLoginForm',
      'click .signup': 'openSignupForm',
      'click .cancel': 'goHome'
    }

    openLoginForm: (event) ->
      card = @$el.find('#user-actions .flip')
      card.find('.back').html ich.loginTmp()
      card.flip()
      @delegateEvents()

    openSignupForm: (event) ->
      card = @$el.find('#user-actions .flip')
      card.find('.back').html ich.signupTmp()
      card.flip()
      @delegateEvents()

    goHome: (event) ->
      @$el.find('#user-actions .flip').flip()

    render: ->
      @$el.html ich.homeTmp()

  @HomeView = HomeView
