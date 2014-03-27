request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
app = require('../server')(8100, 'test')
User = require '../app/models/user'
serverUrl = 'http://localhost:8100'

before (done) ->
  User.remove ->
    user = new User { email: 'valid@user.com', password: '123password' }
    user.save (error) ->
      throw error if error
      done()

after (done) ->
  User.remove ->
    done()

describe 'proxy creation', ->

  it 'should create a new IRC proxy belonging to the logged in user', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'valid@user.com', password: '123password'
      .end (err, res) ->
        agent
          .post "#{serverUrl}/session/create"
          .end (err, res) ->
            res.req.path.should.equal '/home'
            done()
