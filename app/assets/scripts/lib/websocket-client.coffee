root = exports ? this

class WebsocketClient

  constructor: (@url, @events) ->
    console.log "websocket client created with url: #{@url}"

  connect: =>
    @socket = io.connect(@url)

    @socket.on 'open', =>

      console.log "opened"

      @socket.on 'message', (data) =>
        console.log "client received #{data}"
        # @socket.send 'ping'

      @socket.on 'close', =>

  send: (command, data) =>
    console.log "emitting: #{command} with data: #{data}"
    @socket.emit command, { options: data }

root.WebsocketClient = WebsocketClient
