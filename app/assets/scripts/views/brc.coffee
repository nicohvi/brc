root = exports ? this

class BRCView

  constructor: (@events) ->
    @view = $('#irc')
    @connect = $('#connect')
    @websocketClient = new WebsocketClient('localhost', @events)
    @websocketClient.connect()
    @initBindings()

  # initListeners: =>
  #   @events.addListener 'irc_proxy:connected', =>
  #     @websocketClient = new WebsocketClient('ws://localhost/', @events)
  #     @websocketClient.connect()

  initBindings: =>
    @connect.on 'click', (event) =>
      $el = @connect
      @websocketClient.emit 'connectToIRC', { proxyId: $el.data('proxy-id') }


root.BRCView = BRCView
