require './spec_helper'

request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
User = require '../app/models/user'
IRCProxy = require '../app/models/irc-proxy'
serverUrl = 'http://localhost:8100'
util = require 'util'

describe 'irc-config path', ->

  before (done) ->
    user = new User { email: 'valid@user.com', password: '123password' }
    user.save (error) ->
      throw error if error
      done()

  after (done) ->
    IRCProxy.remove ->
      User.remove ->
        done()

  it 'should return 400 for submitting empty form', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'valid@user.com', password: '123password'
      .end (err, res) ->
        agent
          .post "#{serverUrl}/irc-config"
          .end (err, res) ->
            res.status.should.equal 400
            res.text.should.include 'empty form'
            done()

  it 'should return 200 when submitting a valid form', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'valid@user.com', password: '123password'
      .end (err, res) ->
        agent
          .post "#{serverUrl}/irc-config"
          .send nick: 'SeverinLovaas'
          .end (err, res) ->
            res.status.should.equal 200
            done()


describe 'Proxy creation and updating', ->

  before (done) ->
    user = new User { email: 'valid@user.com', password: '123password' }
    user2 = new User { email: 'also-valid@user.com', password: '123password' }

    user.save (error) ->
      throw error if error
      ircProxy = new IRCProxy { _user: user._id }
      ircProxy.save (error) ->
        throw error if error
      user2.save (error) ->
      throw error if error
      done()

  afterEach (done) ->
    User.findOne( { email: 'also-valid@user.com' }, (err, user) ->
      IRCProxy.remove( { _user: user._id }, (err) ->
        done()
      ) # proxy.findOne
    ) # user.findOne

  after (done) ->
    IRCProxy.remove ->
      User.remove ->
        done()

  it 'should create a new proxy for the logged in User when none exists', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'also-valid@user.com', password: '123password'
      .end (err, res) ->
        res.text.should.include 'also-valid@user.com'
        IRCProxy.find({}, (err, proxies) ->
          proxies.length.should.equal 1
          agent
          .post "#{serverUrl}/irc-config"
          .send nick: 'RetardedBear'
          .end (err, res) ->
            res.status.should.equal 200
            res.text.should.include 'Proxy created'
            res.text.should.include 'RetardedBear'
            IRCProxy.find({}, (err, proxies) ->
              proxies.length.should.equal 2
              done()
            )
        )

  it 'should not create a new proxy for the logged in user when one exists', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'valid@user.com', password: '123password'
      .end (err, res) ->
        res.text.should.include 'valid@user.com'
        IRCProxy.find({}, (err, proxies) ->
          proxies.length.should.equal 1
          agent
          .post "#{serverUrl}/irc-config"
          .send nick: 'RetardedBear'
          .end (err, res) ->
            res.status.should.equal 200
            IRCProxy.find({}, (err, proxies) ->
              proxies.length.should.equal 1
              done()
            )
        )

  it 'should update the existing proxy for the logged in User when one exists', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'valid@user.com', password: '123password'
      .end (err, res) ->
        res.text.should.include 'valid@user.com'
        agent
        .post "#{serverUrl}/irc-config"
        .send nick: 'RetardedBear', server: 'irc.freenode.net'
        .end (err, res) ->
          res.status.should.equal 200
          res.text.should.include 'Proxy updated'
          res.text.should.include 'RetardedBear'
          res.text.should.include 'freenode'
          done()
