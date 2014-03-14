spawn = require('child_process').spawn
server = require '../utils/server.coffee'
config = require '../utils/config'
express = require 'express'
fs = require 'fs'
app = server.app

# set up envirnoment variables
# use jade for view templates
app.set('view engine', 'jade')

# TODO: use winston for logging
app.use(express.logger())

# set environment variables
app.use(express.static("../public"))

# load the controllers
require('./init')(app, { verbose: true} )

server.start 8100, ->
  jasmineNode = spawn('jasmine-node',
                      [ '../spec', '--coffee', '--color', '--verbose',
                      '--junitreport', '--output', '../spec/reports'])

  logToConsole = (data) ->
    console.log(String(data))

  jasmineNode.stdout.on('data', logToConsole);
  jasmineNode.stderr.on('data', logToConsole);

  jasmineNode.on('exit', (exitCode) ->
    server.close())
