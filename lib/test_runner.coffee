spawn = require('child_process').spawn
server = require '../utils/server.coffee'
config = require '../utils/config'
express = require 'express'
fs = require 'fs'
app = server.app

# set up envirnoment variables
# use jade for view templates
app.set('view engine', 'jade')
app.set('views', "../app/views")

# TODO: use winston for logging
app.use(express.logger())

# set environment variables
app.use(express.static("../public"))
app.use(app.router)

# load the controllers
fs.readdirSync("../app/controllers").forEach (file) ->
  route = require "../app/controllers/#{file}"
  route.controller(app)

server.start 8100, ->
  jasmineNode = spawn('jasmine-node',
                      ['--coffee', '--color', '--autotest', '../spec/'])

  logToConsole = (data) ->
    console.log(String(data))

  jasmineNode.stdout.on('data', logToConsole);
  jasmineNode.stderr.on('data', logToConsole);

  jasmineNode.on('exit', (exitCode) ->
    server.close())
