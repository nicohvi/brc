assert = require 'assert'
request = require 'supertest'
app = require('../server')(8100)

describe 'root path', ->
  it 'should return status 200 OK', (done) ->
    request(app)
      .get('/')
      .expect(200)
    done()
