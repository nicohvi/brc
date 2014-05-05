$ =>

  deferred = Q.defer()

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
      formData =
        username: $('input[name=username]').val(),
        password: $('input[name=password]').val()

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
      formData =
        username: $('input[name=username]').val(),
        password: $('input[name=password]').val(),
        password_confirmation: $('input[name=password_confirmation]').val()

      Q.fcall(@validateForm, formData)
      .then(
        () ->
          $.post('/signup', JSON.stringify @serializeForm() )
          .done (data) ->
            debugger
          .fail (jqXHR) ->
      )
      .fail(
        (error) =>
          @trigger 'error', error
      )
      .done()

    handleError: (error) =>
      $field = $("input[name=#{error.field}]")
      $field.parents('.form-element').addClass('error')
      $('<div class="notice"></div>')
        .css(top: "#{$field.offset().top+6}px", left: "#{$field.offset().left+$field.outerWidth()+20}px")
        .html(error.message)
        .addClass('show')
        .prependTo('body')

    clearNotice: (event) ->
      @$el.find('.notice').fadeOut('fast', () -> $(@).removeClass('error'))

    loggedIn: (user) ->
      @$el.find('.notice').removeClass('error').html("Logged in as #{user.username}").fadeIn('fast')

    render: ->
      @$el.html ich.homeTmp()

    validateForm: (params) ->
      for name, value of params
        unless value.length > 0
          throw new ValidationError(name, 'required')
        if name == 'username' && !validator.isEmail(value)
          throw new ValidationError(name, 'email')

  @HomeView = HomeView
