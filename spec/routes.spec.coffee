require './spec_helper'

describe 'app', ->

  describe 'root', ->
    it 'should respond with status 200', (done) ->
      get '/', (error, response, body) ->
        expect(response.statusCode).toEqual 200
        done()

    it 'should respond with the appropriate body', (done) ->
      get '/', (error, response, body) ->
        expect(body).toEqual 'Hello world'
        done()

  describe 'test', ->
    it 'should respond with the appropriate body', (done) ->
      get '/test', (error, response, body) ->
        expect(body).toEqual 'Test route'
        done()
