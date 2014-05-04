# application entry point

config = require '../../config'
app = require('./webserver').app
server = require('./webserver').server
io = require 'socket.io'
Schema = require('jugglingdb').Schema
uuid = require 'node-uuid'
modelMapper = require './models'
util = require 'util'

class Brc

  constructor: () ->
    @app = app
    @app.config = config

  start: () =>
    schema = new Schema config.database.adapter, {
      database: config.database.name,
      username: config.database.username
    }

    # map our model schemas to the database ORM
    @app.db = modelMapper(schema)

    # connect socket.io with our app's server
    @app.io = io.listen(server)
    @app.io.set('log level', 3) if config.debug

    # setup route API
    require('./routes')(@app)

    # setup the IRC manager to connect our app to node-irc
    require('./irc-manager')(@app)
    socketManager = require './socket'
    @app.io.sockets.on 'connection', (socket) ->
      socketManager(socket, @app)

    console.log "brc started on port #{server.address().port}" if server.address()

module.exports = Brc
