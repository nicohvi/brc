request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
app = require('../../server')(8100, 'test')
User = require '../../app/models/user'
IRCProxy = require '../../app/models/irc-proxy'
serverUrl = 'http://localhost:8100'

before (done) ->
  IRCProxy.remove ->
    User.remove ->
      user = new User { email: 'valid@user.com', password: '123password' }
      user.save (error) ->
        throw error if error
        done()

afterEach (done) ->
  IRCProxy.remove ->
    done()

after (done) ->
  User.remove ->
    IRCProxy.remove ->
      done()

describe 'proxy creation', ->

  it 'should not create an IRC proxy without a user', (done) ->
    ircProxy = new IRCProxy()
    ircProxy.save (error) ->
      error.should.be.ok
      IRCProxy.find {}, (error, proxies) ->
        should.equal(error, null)
        proxies.length.should.equal 0
        done()

  it 'should create a new IRC proxy for a user without one previously', (done) ->
    User.findOne( { email: 'valid@user.com' }, (error, user) ->
      ircProxy = new IRCProxy { _user: user._id }
      ircProxy.save (error) ->
        should.equal(error, null)
        IRCProxy.find {}, (error, proxies) ->
          should.equal(error, null)
          proxies.length.should.equal 1
          done()
    ) # findOne

  it 'should not create an IRC proxy for a user with a proxy already', (done) ->
    User.findOne( { email: 'valid@user.com' }, (error, user) ->
      ircProxy = new IRCProxy { _user: user._id }
      ircProxy.save (error) ->
        should.equal(error, null)
      ircProxy2 = new IRCProxy { _user: user.id }
      ircProxy2.save (error) ->
        error.should.be.ok
        IRCProxy.find {}, (error, proxies) ->
          should.equal(error, null)
          proxies.length.should.equal 1
          done()
    ) # findOne
