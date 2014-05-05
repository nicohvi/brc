$ =>

  class LoginView extends Backbone.View

    initialize: (opts) ->
      @setElement('#login-form')
      @parent = opts.parent
      @render()

    events: {
      'click #login':  'login',
      'click .cancel': 'close'
    }

    render: ->
      @$el.html ich.loginTmp()

    login: (event) =>
      @parent.trigger 'clear_errors'

      formData =
        username: $('input[name=username]').val(),
        password: $('input[name=password]').val()

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

  @LoginView = LoginView
