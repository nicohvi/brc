$ =>

  class HomeView extends Backbone.View

    initialize: ->
      @setElement('#home')

      # events
      @bind('close_form', @goHome)
      @bind('error', @handleError)
      @bind('clear_errors', @clearErrors)

      @render()
      @card = @$el.find('#user-actions .flip')

    events: {
      'click .login':  'openLoginForm',
      'click .signup': 'openSignupForm'
    }

    openLoginForm: (event) =>
      @card.find('.back').html('<section id="login-form"></section>')
      @login = new LoginView { parent: @ }
      @card.flip()

    openSignupForm: (event) ->
      @card.find('.back').html('<section id="signup-form"></section>')
      @signup = new SignupView { parent: @ }
      @card.flip()

    goHome: (event) ->
      $('.notice').removeClass('show left right')
      @$el.find('#user-actions .flip').flip()

    handleError: (error) =>
      $field = $("input[name=#{error.field}]")
      $field.parents('.form-element').addClass('error')

      if $field.next('aside').length > 0
        _class = 'left'
        leftPosition = $field.offset().left-120
      else
        _class = 'right'
        leftPosition = $field.offset().left+$field.outerWidth()+20

      $('.notice')
        .css(top: "#{$field.offset().top+6}px", left: "#{leftPosition}px")
        .html(error.message)
        .addClass("show #{_class}")

    clearErrors: (event) ->
      $('.error').removeClass('error')
      $('.notice').removeClass('show left right')

    validateForm: (params) ->
      for name, value of params
        unless value.length > 0
          throw new ValidationError(name, 'Required')
        if name == 'username' && !validator.isEmail(value)
          throw new ValidationError(name, 'Invalid email')

    render: ->
      @$el.html ich.homeTmp()

  @HomeView = HomeView
