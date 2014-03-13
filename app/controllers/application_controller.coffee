User = require '../models/user'
db = require '../../utils/db'

module.exports.controller = (app) ->

  # root route
  app.get '/', (req, res) ->

    res.render 'application/index'
