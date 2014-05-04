$ =>

  class HomeView extends Backbone.View

    initialize: ->
      @setElement('#home')
      @render()
      @bind('error', @handleError)
      @bind('logged_in', @loggedIn)

    events: {
      'click .login':  'openLoginForm',
      'click .signup': 'openSignupForm',
      'click .cancel': 'goHome',
      'click #login':  'login',
      'click #signup': 'signup',
      'click .notice': 'clearNotice'
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

    login: (event) =>
      $.post('/login', JSON.stringify @serializeForm() )
      .done (data) =>
        response = JSON.parse(data)
        if response.error?
          @trigger 'error', response.error
        else
          @trigger 'logged_in', response.user

      .fail (jqXHR) =>
        @trigger 'error', jqXHR

    signup: (event) ->
      $.post('/signup', JSON.stringify @serializeForm() )
      .done (data) ->
        debugger
      .fail (jqXHR) ->

    handleError: (error) ->
      @$el.find('.notice').addClass('error').html(error.message).fadeIn('fast')

    clearNotice: (event) ->
      @$el.find('.notice').fadeOut('fast', () -> $(@).removeClass('error'))

    loggedIn: (user) ->
      @$el.find('.notice').removeClass('error').html("Logged in as #{user.username}").fadeIn('fast')

    serializeForm: ->

      formData =
        username: $('input[name=username]').val(),
        password: $('input[name=password]').val()

    render: ->
      @$el.html ich.homeTmp()

  @HomeView = HomeView
