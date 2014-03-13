server = require './utils/server'
config = require ('./utils/config')
app = server.app
fs = require 'fs'
database = require './utils/db'
express = require 'express'

# use jade for view templates
app.set('view engine', 'jade')
app.set('views', "#{__dirname}/app/views")

# TODO: use winston for logging
app.use(express.logger())

# set environment variables
app.set('port', process.env.port || 8000)
app.use(express.static("#{__dirname}/public"))
app.use(app.router)

# load the controllers
fs.readdirSync("#{__dirname}/app/controllers").forEach (file) ->
  route = require "#{__dirname}/app/controllers/#{file}"
  route.controller(app)

# start the server
server.start app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"
