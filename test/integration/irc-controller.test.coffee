require '../spec_helper'

superagent = require 'superagent'
should = require 'should'
User = require '../../app/models/user'
IRCProxy = require '../../app/models/irc-proxy'
serverUrl = 'http://localhost:8100'
util = require 'util'
cheerio = require 'cheerio'

describe 'connect to the given IRC server through BRC', ->
  before (done) ->
    user = new User { email: 'valid@user.com', password: '123password' }
    user.save (error) ->
      throw error if error
      ircProxy = new IRCProxy {
        _user: user._id,
        nick: 'RetardedTest',
        servers: [ url: 'leguin.freenode.net', channels: [] ]
      }
      ircProxy.save (error) =>
        throw error if error
        done()

  after (done) ->
    User.remove ->
      IRCProxy.remove ->
        done()

  it 'should connect to the registered IRC server through the proxy', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'valid@user.com', password: '123password'
      .end (err, res) ->
        $ = cheerio.load(res.text)
        proxyId = $('#connect').attr('data-proxy-id')
        agent
        .post "#{serverUrl}/connect"
        .send proxyId: proxyId
        .end (err, res) ->
          res.status.should.equal 200
          done()