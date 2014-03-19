class Server

  @start: (app, port, callback) ->
    unless @server then @server = app.listen(port, callback)

  close: ->
    @server.close()

module.exports = Server
