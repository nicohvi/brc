$ =>

  class SignupView extends Backbone.View

    initialize: (opts) ->
      @setElement('#signup-form')
      @parent = opts.parent
      @render()

    events: {
      'click #signup':  'signup',
      'click .cancel': 'close'
    }

    render: ->
      @$el.html ich.signupTmp()

    signup: (event) =>
      @parent.trigger 'clear_errors'

      formData =
        username: $('input[name=username]').val(),
        password: $('input[name=password]').val(),
        password_confirmation: $('input[name=password_confirmation]').val()

      Q.fcall(@parent.validateForm, formData)
      .then(
        () ->
          Q($.post('/login', JSON.stringify formData ))
          .then(
            () ->
              debugger
          )
          .fail(
            () ->
              debugger
          )
          .done()
      )
      .fail(
        (error) =>
          @parent.trigger 'error', error
      )
      .done()

    close: () =>
      @parent.trigger 'close_form'
      @$el.fadeOut('fast', () => @remove())

  @SignupView = SignupView
