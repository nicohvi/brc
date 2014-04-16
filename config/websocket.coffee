util = require 'util'

startSocketServer = (server) ->
  IRCProxy = require '../app/models/irc-proxy'
  io = require('socket.io').listen(server)

  io.sockets.on 'connection', (socketClient) ->

    socketClient.on 'connectToIRC', (data) ->
      console.log "server received connectToIRC with: #{util.inspect data}"

      # set up listeners from node-irc
      IRCProxy.findOne( { _id: data.proxyId }, (err, proxy) ->
        proxy.createClient()
        ircEvents = proxy.events

        ircEvents.on 'registered', ->
          socketClient.emit 'registered'

        ircEvents.on 'message', (message) ->
          socketClient.emit 'message', message

      ) # proxy.findOne

    # set up listeners from client
    socketClient.on 'message', (data) ->
      console.log "server received #{data}"
      socketClient.send "pong"


exports.startSocketServer = startSocketServer
