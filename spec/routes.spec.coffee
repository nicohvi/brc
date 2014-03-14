require './spec_helper'

describe 'app', ->

  describe 'root', ->

    it 'should prompt me for a login if no user is signed in', (done) ->
      get '/', {}, (error, response, body) ->
        expect(response.statusCode).toEqual 302
        done()

    it 'should respond with status 200 if user is logged in', (done) ->
      options = { user:
                    username: 'Ford',
                    password: 'towel'
                }
      get '/', options, (error, response, body) ->
        expect(response.statusCode).toEqual 200
        done()
