require '../spec_helper'

request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
User = require '../../app/models/user'
IRCProxy = require '../../app/models/irc-proxy'

describe 'IRC server schema', ->

  before (done) ->
    user = new User { email: 'valid@user.com', password: '123password' }
    user.save (error) ->
      throw error if error
      ircProxy = new IRCProxy {
        _user: user._id,
        servers:
          [ { url: 'irc.server.net', channels: [ ] },
            { url: 'irc.nplol.com', channels: [ ] }
          ]
      }
      ircProxy.save (error) ->
        throw error if error
        done()

  after (done) ->
    User.remove ->
      IRCProxy.remove ->
        done()

  it 'should have two servers registered to the user\'s proxy', (done) ->
    user = User.findOne( { email: 'valid@user.com' }, (error, user) ->
      IRCProxy.findOne( { _user: user._id }, (error, proxy) ->
        proxy.servers.length.should.eql 2
        proxy.servers[0].url.should.eql 'irc.server.net'
        proxy.servers[1].url.should.eql 'irc.nplol.com'
        done()
      ) #ircProxy.findOne
    ) # user.findOne
