require './spec_helper'

describe 'app', ->

  describe 'root', ->
    it 'should respond with status 200', (done) ->
      get '/', (error, response, body) ->
        expect(response.statusCode).toEqual 200
        done()
