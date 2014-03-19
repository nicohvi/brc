Server = require '../utils/server.coffee'
spawn = require('child_process').spawn
# config = require '../utils/config'
express = require 'express'
fs = require 'fs'
passport = require 'passport'
passportMock = require '../spec/mock/passport_mock'
# User = require '../app/models/user'

app = express()
server = new Server(8100, app)

callback = ->
  jasmineNode = spawn('jasmine-node',
                      [ '../spec', '--coffee', '--color', '--verbose',
                      '--junitreport', '--output', '../spec/reports'])

  logToConsole = (data) ->
    console.log(String(data))

  jasmineNode.stdout.on('data', logToConsole);
  jasmineNode.stderr.on('data', logToConsole);

  jasmineNode.on('exit', (exitCode) ->
    server.close())

# use jade for view templates
app.set('view engine', 'jade')

# TODO: use winston for logging
app.use(express.logger())

# set environment variables
app.use(express.static("../public"))

# load the controllers
require('./init')(app, { verbose: true} )

app.use express.cookieParser()

# use sessions
session = { secret: 'keyboard cat' }
app.use express.session(session)
app.use passport.initialize()
app.use passport.session(session)
passportMock.mock(app)

server.start(callback)
