# User = require '../app/models/user'
# database = require '../utils/db'
# util = require 'util'
# supertest = require 'supertest'
# passportMock = require './mock/passport_mock'
# passport = require 'passport'


describe 'app', ->

  describe 'root', ->

    it 'should prompt me for a login if no user is signed in', (done) ->
      get('/', (error, response, body) ->
        req = response.request
        expect(req._redirectsFollowed).toBeGreaterThan 0
        expect(req.uri.path).toEqual '/login'
        done()
      )

    it 'should remain on the index page if a user is signed in', (done) ->
      # log the dummy user in through passport mock
      get '/login!', (error, response, body) ->
        req = response.request
        expect(req.uri.path).toEqual '/'
