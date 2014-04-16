root = exports ? this

class WebsocketClient

  constructor: (@url, @events) ->
    console.log "websocket client created with url: #{@url}"

  connect: =>
    @socket = io.connect(@url)

    @socket.on 'message', (data) =>
      console.log "client received #{data}"

    @socket.on 'registered', (data) =>
      console.log "client received registered"

    @socket.on 'close', =>

  emit: (command, data) =>
    console.log "emitting: #{command}"
    @socket.emit command, data

root.WebsocketClient = WebsocketClient
