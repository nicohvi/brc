root = exports ? this

class BRCView

  constructor: (@events) ->
    @view = $('#irc')
    @initListeners()

  initListeners: =>
    @events.addListener 'irc_proxy:connected', =>
      @websocketClient = new WebsocketClient('ws://localhost/', @events)
      @websocketClient.connect()

    # add listeners which will react to messages from the websocket client.


root.BRCView = BRCView
