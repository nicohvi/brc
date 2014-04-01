request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
app = require('../server')(8100, 'test')
User = require '../app/models/user'
IRCProxy = require '../app/models/irc-proxy'
serverUrl = 'http://localhost:8100'


before (done) ->
  IRCProxy.remove ->
    User.remove ->
      user = new User { email: 'valid@user.com', password: '123password' }
      user.save (error) ->
        throw error if error
        ircProxy = new IRCProxy { _user: user._id }
        ircProxy.save (error) ->
          throw error if error
          done()

after (done) ->
  IRCProxy.remove ->
    User.remove ->
      done()

# describe 'Sets the IRC config for a User\'s IRC proxy', ->
#
#   it 'should set the IRC nick for the logged in user', (done) ->
#     agent = superagent.agent()
#     nick = 'RetardedBear'
#
#     agent
#       .post "#{serverUrl}/irc-config/"
#       .send nick: nick
#       .end (err, res) ->
#         res.text.should.include "#{nick}, huh? Classy."
#         done()
