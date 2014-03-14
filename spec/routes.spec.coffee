require './spec_helper'
User = require '../app/models/user'

describe 'app', ->

  describe 'root', ->

    beforeEach((done) ->
      user = new User({
        email: 'test@test.com',
        username: 'retardedTest',
        password: '123password'
      })
      user.save()
    )

    afterEach((done) ->

    )
    it 'should prompt me for a login if no user is signed in', (done) ->
      get '/', {}, (error, response, body) ->
        request = response.request
        expect(request._redirectsFollowed).toBeGreaterThan 0
        expect(request.uri.path).toEqual '/login'
        done()

    it 'should remain on the index page if user is signed in', (done) ->
      get '/', (error, response, body) ->
        request = response.request
        expect(request._redirectsFollowed).toEqual 0
        expect(request.uri.path).toEqual '/'
        expect(body).toContain 'channels'
        done()
