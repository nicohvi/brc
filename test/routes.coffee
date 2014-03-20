request = require 'supertest'
should = require 'should'
app = require('../server')(8100)

describe 'root path', ->
  it 'should return status 200 OK', (done) ->
    request(app)
      .get('/')
      .expect(200)
      .end((err, res) ->
        res.text.should.include("Welcome")
        done()
      )

describe 'login path', ->
  it 'should return status 200 OK', (done) ->
    request(app)
      .get('/login')
      .expect(200)
      .end((err, res) ->
        res.text.should.include("login")
        done()
      )

describe 'signup path', ->
  it 'should return status 200 OK', (done) ->
    request(app)
      .get('/signup')
      .expect(200)
      .end((err, res) ->
        res.text.should.include("signup")
        done()
      )
