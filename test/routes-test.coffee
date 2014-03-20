request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
User = require '../app/models/user'
database = require('mongoose').connection
# inspect = require('util').inspect
app = require('../server')(8100, 'test')

describe 'root path', ->

  after (done) ->
    User.collection.remove( (error, user) ->
      done()
    )

  it 'should return status 200 OK', (done) ->
    request(app)
      .get '/'
      .expect 200
      .end((err, res) ->
        res.text.should.include("Welcome")
        done()
      )

describe 'login path', ->
  it 'should return status 200 OK', (done) ->
    request(app)
      .get '/login'
      .expect 200
      .end( (err, res) ->
        res.text.should.include("login")
        done()
      )

  it 'should return 302 for incorrect login', (done) ->
    request(app)
      .post '/login'
      .send email: 'test@test.com', password: '123password'
      .expect 302
      .end( (err, res) ->
          res.redirect.should.be.true
          res.header.location.should.equal('/login')
          done()
      )

  it 'should login user with correct login', (done) ->
    agent = superagent.agent()

    user = new User { email: 'valid@user.com', password: '123password' }
    user.save((error) ->
      throw error if error
    )

    agent
      .post 'http://localhost:8100/login'
      .send email: 'valid@user.com', password: '123password'
      .end( (err, res) ->
        res.should.have.status 200
        res.text.should.include 'Channels'
        done()
      )
# describe 'signup path', ->
#   it 'should return status 200 OK', (done) ->
#     request(app)
#       .get('/signup')
#       .expect(200)
#       .end((err, res) ->
#         res.text.should.include("signup")
#         done()
#       )
