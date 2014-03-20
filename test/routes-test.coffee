request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
User = require '../app/models/user'
# inspect = require('util').inspect
app = require('../server')(8100, 'test')
serverUrl = 'http://localhost:8100'

before (done) ->
  user = new User { email: 'valid@user.com', password: '123password' }
  user.save (error) ->
    throw error if error
    done()


after (done) ->
  User.collection.remove (error, user) ->
    done()

describe 'root path', ->

  it 'should return status 200 OK', (done) ->
    request(app)
      .get '/'
      .expect(200, done)

describe 'login path', ->
  it 'should return status 200 OK', (done) ->
    request(app)
      .get '/login'
      .expect(200, done)

  it 'should return 302 for missing login credentials', (done) ->
    request(app)
      .post '/login'
      .expect(302, done)

  it 'should return error message for email when email is not found', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'invalid@user.com', password: 'whatever'
      .end (err, res) ->
        res.text.should.include 'Incorrect email address'
        done()

  it 'should return error message for password when it is wrong', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'valid@user.com', password: 'whatever'
      .end (err, res) ->
        res.text.should.include 'Wrong password, brah'
        done()


  it 'should login user with correct login', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'valid@user.com', password: '123password'
      .end( (err, res) ->
        res.req.path.should.equal '/home'
        done()
      )

describe 'signup path', ->

  it 'should return status 200 OK', (done) ->
    request(app)
      .get '/signup'
      .expect(200, done)

  it 'should return 302 for missing credentials', (done) ->
    request(app)
      .post '/signup'
      .expect(302, done)

  it 'should return error message for existing credentials', (done) ->
    agent = superagent.agent()

    agent
      .post 'http://localhost:8100/signup'
      .send email: 'valid@user.com', password: 'whatever'
      .end (err, res) ->
        res.text.should.include 'already taken'
        done()

  it 'should sign up user with valid credentials', (done) ->
    agent = superagent.agent()

    agent
      .post 'http://localhost:8100/signup'
      .send email: 'valid@new-user.com', password: '123password'
      .end (err, res) ->
        res.req.path.should.equal '/home'
        done()
