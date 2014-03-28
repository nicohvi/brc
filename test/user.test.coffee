should = require 'should'
app = require('../server')(8100, 'test')
User = require '../app/models/user'
util = require 'util'
tools = require './tools'

describe 'User model', ->

  beforeEach (done) ->
    User.remove ->
      done()

  it 'should not create a new user without required fields', (done) ->
    user = new User()
    user.save (errors) ->
      errors.should.be.ok
      keys = tools.getKeysFromObject(errors.errors)
      keys.length.should.equal 2
      keys.should.containEql 'password'
      keys.should.containEql 'email'
      User.find {}, (error, users) ->
        throw error if error
        users.length.should.equal 0
        done()

  it 'should create new user when required fields are supplied', (done) ->
    user = new User { email: 'valid@user.com', password: '123password' }
    user.save (errors) ->
      should.equal(errors, null)
      User.find {}, (error, users) ->
        throw error if error
        users.length.should.equal 1
        users[0].email.should.equal 'valid@user.com'
        done()
