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
      # node-irc client has been registered, now we have the status channel.
      # 1 - create new user object
      # 2 - create new channel object
      # 3 - add channel object to user
      # 4 - display messages from status in the channelView
      User.get() # create/get user singleton
      @events.emit 'add_channel', '#status'

    @socket.on 'close', =>

    done()

  emit: (command, data) =>
    console.log "emitting: #{command}"
    @socket.emit command, data


root.WebsocketController = WebsocketController
