spawn = require('child_process').spawn
server = require '../utils/server.coffee'
config = require '../utils/config'
express = require 'express'
fs = require 'fs'
app = server.app
passport = require 'passport'
passportMock = require '../spec/mock/passport_mock'
User = require '../app/models/user'

# set up envirnoment variables
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

# use passport for auth
# require('./auth')(app)
#mockUser = new User({ email: 'test@test.com', password: '123password' })
#app.use passportMock.initialize(mockUser)
#app.use passport.session()


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
