should = require 'should'
app = require('../../server')(8100, 'test')
User = require '../../app/models/user'
IRCProxy = require '../../app/models/irc-proxy'
util = require 'util'
tools = require '../support/tools'

require '../spec_helper'

describe 'User model', ->

  after (done) ->
    User.remove ->
      done()

  it 'should not create a new user without required fields', (done) ->
    user = new User()
    user.save (errors) ->
      errors.should.be.ok
      keys = tools.getKeysFromObject(errors.errors)
      keys.length.should.equal 2
      keys.should.containEql 'password'
      keys.should.containEql 'email'
      User.find {}, (error, users) ->
        throw error if error
        users.length.should.equal 0
        done()

  it 'should create new user when required fields are supplied', (done) ->
    user = new User { email: 'valid@user.com', password: '123password' }
    user.save (errors) ->
      should.equal(errors, null)
      User.find {}, (error, users) ->
        throw error if error
        users.length.should.equal 1
        users[0].email.should.equal 'valid@user.com'
        done()

  it 'should return the name of the User\'s Proxy', (done) ->
    User.findOne( { email: 'valid@user.com' }, (error, user) ->
      throw error if error
      ircProxy = new IRCProxy { _user: user._id, nick: 'SeverinLovaas' }
      ircProxy.save (error) ->
        throw error if error
        user.getIrcProxy( (error, proxy) ->
          throw error if error
          proxy.nick.should.equal ircProxy.nick
          done()
        ) # getIrcProxy
    ) # findOne
