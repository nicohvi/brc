root = exports ? this

class HomeView

  constructor: (@events) ->
    @view = $('#content')
    @form = $('#irc-config')
    @events.addListener "irc_proxy:submit:success", (response) =>
      @.clearErrors()
      @.updateView(response)
    @events.addListener "irc_proxy:submit:error", (error) =>
      @.showError(error)
    @.initBindings()

  initBindings: ->
    @form.on 'submit', (event) =>
      event.preventDefault()

    @form.on 'keydown', (event) =>
      @.submitForm() if event.keyCode == 13

    @form.find('.confirm').on 'click', (event) =>
      @.submitForm()

    $('.message').on 'click', (event) ->
      $(@).html('').addClass('hidden')

  showError: (error) ->
    @form.find('.alert').removeClass('hidden').html(error.message)

  clearErrors: ->
    @form.find('.alert').html('').addClass('hidden')

  updateView: (data) ->
    debugger

  submitForm: ->
    data = @form.find('input').serialize()

    options =
      url:     @form.attr('action')
      method:  'POST'
      data:    data

    $.ajax(options)
      .done (data) =>   @events.emit "irc_proxy:submit:success", data
      .fail (jqXHR) =>  @events.emit "irc_proxy:submit:error", jqXHR.responseJSON


root.HomeView = HomeView
