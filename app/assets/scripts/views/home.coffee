root = exports ? this

class HomeView

  constructor: (@events) ->
    @view = $('#content')
    @form = $('#irc-config')
    @connect = $('#connect')
    @initListeners()
    @initBindings()

  initListeners: =>
    @events.addListener 'irc_proxy:submit:success', (response) =>
      @clearErrors()
      @updateView(response)

    @events.addListener 'irc_proxy:submit:error', (error) =>
      @showError(error)

  initBindings: =>
    @form.on 'submit', (event) =>
      event.preventDefault()

    @form.on 'keydown', (event) =>
      @submitForm() if event.keyCode == 13

    @form.find('.confirm').on 'click', (event) =>
      @submitForm()

    $('.message').on 'click', (event) ->
      $(@).html('').addClass('hidden')

    $('input + .lock').on 'click', (event) ->
      $input = $(@).prev()
      $input.attr('disabled', (idx, oldAttr) -> !oldAttr)
      $(@).find('i').toggleClass('fa-lock fa-unlock-alt')
      $input.focus() unless $input.attr('disabled')

  clearErrors: =>
    @form.find('.message').html('').removeClass('alert').addClass('hidden')

  updateView: (data) =>
    @form.find('.message').addClass('notice').removeClass('hidden').html(data.message)
    @updateForm(data.proxy)
    @lockForm()

  updateForm: (proxy) =>
    for key, value of proxy
      $("input[name=#{key}]").val(value)

  lockForm: =>
    _.each $('.lock'), (element, index) ->
      $(element).find('i').removeClass('fa-unlock-alt').addClass('fa-lock')
      $(element).prev().attr('disabled', true)

  submitForm: =>
    data = @form.find('input').serialize()

    options =
      url:     @form.attr('action')
      method:  'POST'
      data:    data

    $.ajax(options)
      .done (data) =>   @events.emit 'irc_proxy:submit:success', data
      .fail (jqXHR) =>  @events.emit 'irc_proxy:submit:error', jqXHR.responseJSON


root.HomeView = HomeView
