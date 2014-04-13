require '../spec_helper'

request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
User = require '../../app/models/user'
IRCProxy = require '../../app/models/irc-proxy'
serverUrl = 'http://localhost:8100'
util = require 'util'
_ = require 'underscore'

describe 'Connect to IRC', ->

  before (done) ->
    user = new User { email: 'valid@user.com', password: '123password' }
    user.save (error) ->
      throw error if error
      ircProxy = new IRCProxy {
        _user: user._id,
        nick: 'RetardedTest',
        servers:
          [ { url: 'leguin.freenode.net', channels: ['#derp'] } ]
      }
      ircProxy.save (error) ->
        throw error if error
        done()

  after (done) ->
    User.remove ->
      IRCProxy.remove ->
        done()

  it 'should create a new IRC client', (done) ->
    @.timeout(0)
    IRCProxy.findOne( { nick: 'RetardedTest' }, (err, proxy) ->
      options = {
        server: proxy.servers[0].url,
        nick: proxy.nick
      }
      should.not.exist(proxy.client)
      proxy.createClient( options, (err, client) ->
        client.should.be.ok
        proxy.client.should.be.ok
        done()
      )
    ) # proxy.findOne

  it 'should connect to the given IRC channel(s)', (done) ->
    @.timeout(0)
    IRCProxy.findOne( { nick: 'RetardedTest' }, (err, proxy) ->
      options = {
        server: proxy.servers[0].url,
        nick: proxy.nick,
        channels: proxy.servers[0].channels
      }
      proxy.createClient( options, (err, client) ->
        proxy.connect(options.channels, (client) ->
          _.keys(client.chans).should.containEql options.channels[0]
          done()
        ) # connect
      )
    ) # proxy.findOne
