should = require 'should'
app = require('../server')(8100, 'test')
User = require '../app/models/user'
util = require 'util'

describe 'User model', ->

  it 'should not create a new user without required fields', (done) ->
    user = new User()
    user.save (errors) ->
      errors.should.be.ok
      Object.keys(errors.errors).length.should.equal 2
      Object.keys(errors.errors).should.containEql 'password'
      Object.keys(errors.errors).should.containEql 'email'
      done()
