root = exports ? this

class BRCView

  constructor: (@events) ->
    @view = $('#irc')
    @connect = $('#connect')
    @websocketClient = new WebsocketClient('http://localhost', @events)
    @websocketClient.connect()
    @initBindings()

  # initListeners: =>
  #   @events.addListener 'irc_proxy:connected', =>
  #     @websocketClient = new WebsocketClient('ws://localhost/', @events)
  #     @websocketClient.connect()

  initBindings: =>
    @connect.on 'click', (event) =>
      $el = @connect
      @websocketClient.send 'connectToIRC', { proxyId: $el.data('proxy-id') }
    #   options =
    #     url: $el.attr('href'),
    #     method: 'post',
    #     data: { proxyId: $el.data('proxy-id') }
    #
    #   $.ajax(options)
    #     .done  (data) =>
    #       @events.emit 'irc_proxy:connected'
    #     .fail  (error) =>  @showError(jqXHR.responseJSON)

    # add listeners which will react to messages from the websocket client.


root.BRCView = BRCView
