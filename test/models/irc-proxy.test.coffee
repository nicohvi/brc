require '../spec_helper'

request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
User = require '../../app/models/user'
IRCProxy = require '../../app/models/irc-proxy'


describe 'IRCProxy model', ->

  before (done) ->
    user = new User { email: 'valid@user.com', password: '123password' }
    user.save (error) ->
      throw error if error
      done()

  afterEach (done) ->
    IRCProxy.remove ->
      done()

  after (done) ->
    User.remove ->
      done()

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
          proxies[0]._user.should.eql user._id
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
