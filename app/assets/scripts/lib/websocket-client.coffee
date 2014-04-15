root = exports ? this

class WebsocketClient

  constructor: (@url, @events) ->
    console.log "websocket client created with url: #{@url}"

  connect: =>
    @socket = new eio.Socket @url

    @socket.on 'open', =>

      @socket.send 'ping'

      @socket.on 'message', (data) =>
        console.log "client received #{data}"
        @socket.send 'ping'

      @socket.on 'close', =>

root.WebsocketClient = WebsocketClient
