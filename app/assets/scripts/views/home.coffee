root = exports ? this

class HomeView #extends view

  constructor: (@events) ->
    @view = $('#content')
    @form = $('#irc-config')
    @events.addListener "irc_proxy:submit:success", (response) =>
      @.updateView(response)
    @events.addListener "irc_proxy:submit:error", (error) =>
      @.updateView(error)
    @.initBindings()

  initBindings: ->
    @form.on 'submit', (event) =>
      event.preventDefault()

    @form.on 'keydown', (event) =>
      @.submitForm() if event.keyCode == 13

    @form.find('.confirm').on 'click', (event) =>
      @.submitForm()

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
      .fail (jqXHR) =>  @events.emit "irc_proxy:submit:error", jqXHR


root.HomeView = HomeView
