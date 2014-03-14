server = require './utils/server'
app = server.app
fs = require 'fs'
express = require 'express'

# use jade for view templates
app.set('view engine', 'jade')
app.set('views', "#{__dirname}/app/views")

# TODO: use winston for logging
app.use(express.logger())

# set environment variables
app.set('port', process.env.port || 8000)
app.use(express.static("#{__dirname}/app/assets"))

# load the controllers
require('./lib/init')(app, {})

# use passport for auth
require './lib/auth'

# start the server
server.start app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"
