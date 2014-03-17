User = require '../models/user'
util = require 'util'

# login filter
exports.before = (req, res, next) ->
  # redirect users to login page unless they're logged in or
  # are attempting to do so.
  if ( req.user || ~req.url.indexOf 'login' )
    next()
  else
    res.redirect('/login')

exports.index = (req, res) ->
  res.render 'application/index'

exports.login = (req, res) ->
  res.render 'application/login'
