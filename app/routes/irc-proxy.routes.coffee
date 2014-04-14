User = require '../models/user'
util = require 'util'
_ = require 'underscore'

module.exports = (app, passport) ->

  app.post('/irc-config', isLoggedIn, (req, res) ->
    if req.body and _.keys(req.body).length > 0
      User.findOne( { email: req.user.email }, (error, user) ->
        user.getIrcProxy (error, proxy) ->
          return handleError(res, error) if error
          if proxy?
            proxy.nick = req.body.nick if req.body.nick?
            if req.body.server?
              server = { url: req.body.server, channels: [] }
              proxy.servers.push server
            proxy.save (error) ->
              return handleError(res, error) if error
              res.send { message: 'Proxy updated.', proxy: proxy }
          else
            user.createProxy (error, proxy) ->
              return handleError(res, error) if error
              proxy.nick = req.body.nick if req.body.nick?
              if req.body.servers?
                server = { url: req.body.server, channels: [] }
                proxy.servers.push server
              proxy.save (error) ->
                handleError(error) if error
                res.send { message: 'Proxy created.', proxy: proxy }
    ) # findOne
    else
      res.status 400
      res.send { message: 'Don\'t just submit an empty form, brah' }
  ) # post

isLoggedIn = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect('/')

handleError = (res, error) ->
  res.status 400
  res.send { message: error }
