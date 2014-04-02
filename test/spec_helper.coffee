require 'should'
app = require('../server')(8100, 'test')
User = require '../app/models/user'
IRCProxy = require '../app/models/irc-proxy'

before (done) ->
  IRCProxy.remove ->
    User.remove ->
      done()

after (done) ->
  IRCProxy.remove ->
    User.remove ->
      done()
