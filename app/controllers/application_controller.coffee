User = require '../models/user'

# login filter
exports.before = (req, res, next) ->
  res.redirect('/login') unless req.user

exports.index = (req, res) ->
  res.render 'application/index'

exports.login = (req, res) ->
  res.render 'application/login'
