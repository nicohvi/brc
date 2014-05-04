express = require 'express'
path = require 'path'
http = require 'http'
config = require '../../config'
stylus = require 'stylus'
nib = require 'nib'

app = exports.app = express()
server = exports.server = http.createServer(app)

# nib/stylus config
compile = (str, path) ->
  stylus(str)
    .set 'filename', path
    .set 'compress', true
    .use nib()

app.configure ->
  root = path.join __dirname, '..'
  app.use require('connect-assets')( { src: "#{root}/assets" } )
  app.use '/assets', express.static "#{root}/assets"
  app.use '/img', express.static "#{root}/assets/images"
  app.set 'views', "#{root}/views"

  app.use stylus.middleware( { src: root, compile: compile } )
  app.use express.json()

  # TODO: use winston for logging
  app.use express.logger('dev')

# setup application environments
configureApp = (app, config) ->
  # set environment variables
  app.set('port', config.port)

app.configure 'development', ->
  envConfig = config.dev
  configureApp(app, envConfig)

app.configure 'production', ->
  envConfig = config.prod
  configureApp(app, envConfig)

port = app.get 'port'
server.listen(port)
