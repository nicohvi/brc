engine = require 'engine.io'
util = require 'util'

startSocketServer = (server) ->
  socket = engine.attach(server)

  socket.on 'connection', (client) ->

    client.on 'message', (data) ->
      console.log "server received #{data}"
      client.send "pong"

exports.startSocketServer = startSocketServer
