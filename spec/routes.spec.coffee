require './spec_helper'
User = require '../app/models/user'
database = require '../utils/db'
util = require 'util'
# app = require('../utils/server').app
# passportMock = require './mock/passport_mock'
# passport = require 'passport'

describe 'app', ->

  describe 'root', ->

    it 'should prompt me for a login if no user is signed in', (done) ->
      get '/', (error, response, body) ->
        request = response.request
        expect(request._redirectsFollowed).toBeGreaterThan 0
        expect(request.uri.path).toEqual '/login'
        done()

    it 'should remain on the index page if a user is signed in', (done) ->

      # log the dummy user in through passport mock
      get '/login!', (error, response, body) ->
        console.log "logged in: #{util.inspect(body)}"
      get '/', (error, response, body) ->
        request = response.request
        expect(request._redirectsFollowed).toEqual 0
        expect(request.uri.path).toEqual '/'
        done()
