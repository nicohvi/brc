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
        servers: [
          {
            url: 'leguin.freenode.net',
            channels: [
              {
                name: '#derp',
                history: [],
                status: 'inactive'
              }
              {
                name: '#derp2',
                history: [],
                status: 'inactive'
              }
              {
                name: '#derp3',
                history: [],
                status: 'inactive'
              }
            ]
          }
        ]
      }
      ircProxy.save (error) ->
        throw error if error
        done()

  after (done) ->
    User.remove ->
      IRCProxy.remove ->
        done()

  # it 'should create a new IRC client', (done) ->
  #   @.timeout(0)
  #   IRCProxy.findOne( { nick: 'RetardedTest' }, (err, proxy) ->
  #     options = {
  #       server: proxy.servers[0].url,
  #       nick: proxy.nick
  #     }
  #     should.not.exist(proxy.client)
  #     proxy.createClient( options, ->
  #       proxy.client.should.be.ok
  #       done()
  #     )
  #   ) # proxy.findOne
  #
  # it 'should connect to the given IRC channel(s)', (done)->
  #   @.timeout(0)
  #   IRCProxy.findOne( { nick: 'RetardedTest' }, (err, proxy) ->
  #     options = {
  #       server: proxy.servers[0].url,
  #       nick: proxy.nick,
  #       channels: ['#derp', '#derp2', '#derp3']
  #     }
  #     proxy.createClient( options, ->
  #       proxy.connect(options.channels, ->
  #         _.keys(proxy.client.chans).should.eql options.channels
  #         done()
  #       ) # connect
  #     )
  #   ) # proxy.findOne
  #
  # it 'should speak to the given channel', (done) ->
  #   @.timeout(0)
  #   IRCProxy.findOne( { nick: 'RetardedTest' }, (err, proxy) ->
  #     options = {
  #       server: proxy.servers[0].url,
  #       nick: proxy.nick,
  #       channels: ['#derp', '#derp2', '#derp3']
  #     }
  #     proxy.createClient( options, ->
  #       proxy.connect(options.channels, ->
  #         proxy.say('#derp', 'hullo.', ->
  #           proxy.servers[0].channels[0].history.should.containEql {
  #             from: 'RetardedTest',
  #             to: '#derp',
  #             message: 'hullo.'
  #           }
  #           done()
  #         ) # say
  #       ) # connect
  #     )
  #   ) # proxy.findOne

  # it 'should join a new channel', (done) ->
  #   @.timeout(0)
  #   IRCProxy.findOne( { nick: 'RetardedTest' }, (err, proxy) ->
  #     options = {
  #       server: proxy.servers[0].url,
  #       nick: proxy.nick,
  #       channels: ['#derp', '#derp2', '#derp3']
  #     }
  #     proxy.createClient( options, ->
  #       proxy.join '#derp4', ->
  #         proxy.servers[0].channels.length.should.eql 5
  #         proxy.servers[0].channels.filter( (channel) ->
  #           channel.status == 'active'
  #         ).length.should.eql 1
  #         proxy.servers[0].channels[4].name.should.eql '#derp4'
  #         done()
  #     )
  #   ) # proxy.findOne
  #
  # it 'should part from the specified channel', (done) ->
  #   @.timeout(0)
  #   IRCProxy.findOne( { nick: 'RetardedTest' }, (err, proxy) ->
  #     options = {
  #       server: proxy.servers[0].url,
  #       nick: proxy.nick,
  #       channels: ['#derp', '#derp2', '#derp3']
  #     }
  #     proxy.createClient( options, ->
  #       proxy.join '#derp4', ->
  #         proxy.part '#derp4', ->
  #           proxy.servers[0].channels.length.should.eql 5
  #           proxy.servers[0].channels.filter( (channel) ->
  #             channel.status == 'active'
  #           ).length.should.eql 0
  #           done()
  #     )
  #   ) # proxy.findOne
