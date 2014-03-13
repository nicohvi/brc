request = require 'request'

jasmine.getEnv().addReporter(new jasmine.ConsoleReporter(console.log))

get = (path, callback) ->
  request "http://localhost:8100#{path}", callback

post = (path, body, callback) ->
  request.post {url: "http://localhost:8100#{path}", body: body}, callback

# export methods for usage in the specs
exports.get = get
exports.post = post
