# request = require 'supertest'
# superagent = require 'superagent'
# should = require 'should'
# app = require('../server')(8100, 'test')
# User = require '../app/models/user'
# IRCproxy = require '../app/models/irc-proxy'
# serverUrl = 'http://localhost:8100'
#
# before (done) ->
#   User.remove ->
#     user = new User { email: 'valid@user.com', password: '123password' }
#     user.save (error) ->
#       throw error if error
#       done()
#
# after (done) ->
#   User.remove ->
#     done()
#
# describe 'proxy creation', ->
#
#   it 'should not create an IRC proxy without a user', (done) ->
#     ircProxy = new IRCproxy()
#     IRCProxy.find {}, (error, proxies) ->
#       throw error if error
#       proxies.length.should.equal 0
#       done()
