$ =>

  class HomeView extends Backbone.View

    initialize: ->
      @setElement('#home')
      @render()

    events: {
      'click .login': 'openLoginForm',
      'click .signup': 'openSignupForm',
      'click .cancel': 'goHome',
      'click #login': 'login',
      'click #signup': 'signup'
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

    login: (event) ->
      $.post('/login', JSON.stringify(@serializeForm()))
      .done (data) ->
        debugger

    signup: (event) ->
      $.post('/signup', JSON.stringify(@serializeForm()))
      .done (data) ->
        debugger

    serializeForm: ->
      formData =
        username: $('input[name=username]').val(),
        password: $('input[name=password]').val()

    render: ->
      @$el.html ich.homeTmp()

  @HomeView = HomeView
