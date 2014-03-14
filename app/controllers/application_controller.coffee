User = require '../models/user'
db = require '../../utils/db'

# login filter
exports.before = (req, res, next) ->
  res.redirect('/login') unless req.user

exports.index = (req, res) ->
  res.render 'application/index'
