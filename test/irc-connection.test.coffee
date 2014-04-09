require './spec_helper'

request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
User = require '../app/models/user'
IRCProxy = require '../app/models/irc-proxy'
serverUrl = 'http://localhost:8100'
util = require 'util'


describe 'Proxy creation', ->

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
        agent
        .post "#{serverUrl}/irc-config"
        .send nick: 'RetardedBear'
        .end (err, res) ->
          res.status.should.equal 200
          res.text.should.include 'Proxy created'
          res.text.should.include 'RetardedBear'
          done()

  it 'should update the existing proxy for the logged in User when one exists', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'valid@user.com', password: '123password'
      .end (err, res) ->
        res.text.should.include 'valid@user.com'
        agent
        .post "#{serverUrl}/irc-config"
        .send nick: 'RetardedBear', servers: [ { url: 'irc.freenode.net', channels: [ ] } ]
        .end (err, res) ->
          res.status.should.equal 200
          res.text.should.include 'Proxy updated'
          res.text.should.include 'RetardedBear'
          res.text.should.include 'freenode'
          done()
