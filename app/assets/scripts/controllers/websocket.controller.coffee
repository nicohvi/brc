root = exports ? this

class WebsocketController

  constructor: (@events) ->
    @url = 'localhost'
    @initListeners()
    console.log "websocket-controller created with url: #{@url}"

  initListeners: =>
    @events.on 'connectToIRC', (proxyId) =>
      @connect =>
        @emit 'connectToIRC', { proxyId: proxyId }

  connect: (done) =>
    @socket = io.connect(@url)

    @socket.on 'message', (message) =>
      console.log "client received #{JSON.stringify message}"
      @events.emit 'message', message

    @socket.on 'registered', (user) =>
      User.get() # create/get user singleton
      @events.emit 'add_channel', '#status'

    @socket.on 'close', =>

    done()

  emit: (command, data) =>
    console.log "emitting: #{command}"
    @socket.emit command, data


root.WebsocketController = WebsocketController
