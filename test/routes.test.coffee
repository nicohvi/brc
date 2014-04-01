request = require 'supertest'
superagent = require 'superagent'
should = require 'should'
app = require('../server')(8100, 'test')
User = require '../app/models/user'
IRCProxy = require '../app/models/irc-proxy'
serverUrl = 'http://localhost:8100'

before (done) ->
  IRCProxy.remove ->
    User.remove ->
      user = new User { email: 'valid@user.com', password: '123password' }
      user.save (error) ->
        throw error if error
        done()


after (done) ->
  IRCProxy.remove ->
    User.remove ->
      done()

describe 'root path', ->

  it 'should return status 200 OK', (done) ->
    request(app)
      .get '/'
      .expect(200, done)

describe 'login path', ->

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

  it 'should return 302 for missing credentials', (done) ->
    request(app)
      .post '/signup'
      .expect(302, done)

  it 'should return error message for existing credentials', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/signup"
      .send email: 'valid@user.com', password: 'whatever'
      .end (err, res) ->
        res.text.should.include 'already taken'
        done()

  it 'should sign up user with valid credentials', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/signup"
      .send email: 'valid@new-user.com', password: '123password'
      .end (err, res) ->
        User.find {}, (error, users) ->
          users.length.should.equal 2 unless error
        res.req.path.should.equal '/home'
        done()

describe 'irc-config path', ->

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

  it 'should return the User to the home path with the updated nick', (done) ->
    agent = superagent.agent()

    agent
      .post "#{serverUrl}/login"
      .send email: 'valid@user.com', password: '123password'
      .end (err, res) ->
        agent
        .post "#{serverUrl}/irc-config"
        .send nick: 'RetardedBear'
        .end (err, res) ->
          res.status.should.equal 200
          res.text.should.include 'RetardedBear, huh?'
          done()
