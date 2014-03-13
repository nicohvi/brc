module.exports.controller = (app) ->

  # root route
  app.get '/', (req, res) ->
    res.render 'application/index'
