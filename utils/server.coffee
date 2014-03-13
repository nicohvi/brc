express = require 'express'
exports.app = app = express()
app.set('root', './')

exports.start = (port, callback) ->
  unless @.server
    @.server = app.listen(port, callback)
    callback if callback?

exports.close = () ->
  @.server.close()
