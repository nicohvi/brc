request = require 'request'

# log to the console
jasmine.getEnv().addReporter(new jasmine.ConsoleReporter(console.log))

# 500 ms for default timeout
jasmine.getEnv().defaultTimeoutInterval = 500

get = (path, options, callback) ->
  for key of options
    request[key] = options[key]
  request "http://localhost:8100#{path}", callback

post = (path, options, body, callback) ->
  request.post {url: "http://localhost:8100#{path}", body: body}, callback

# export methods for usage in the specs
exports.get = get
exports.post = post
