util = require 'util'

startSocketServer = (server) ->
  io = require('socket.io').listen(server)

  io.sockets.on 'connection', (client) ->

    client.on 'connectToIRC', (data) ->
      console.log "server received connectToIrc with: #{util.inspect data}"
      client.send "pong"

    client.on 'message', (data) ->
      console.log "server received #{data}"
      client.send "pong"


exports.startSocketServer = startSocketServer
