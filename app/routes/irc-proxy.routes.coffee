User = require '../models/user'
IRCProxy = require '../models/irc-proxy'
util = require 'util'
_ = require 'underscore'
engine = require '../../config/engine'

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
              proxy.servers.unshift server
            proxy.save (error) ->
              return handleError(res, error) if error
              res.send { message: 'Proxy updated.', proxy: proxy }
          else
            user.createProxy (error, proxy) ->
              return handleError(res, error) if error
              proxy.nick = req.body.nick if req.body.nick?
              if req.body.servers?
                server = { url: req.body.server, channels: [] }
                proxy.servers.unshift server
              proxy.save (error) ->
                handleError(error) if error
                res.send { message: 'Proxy created.', proxy: proxy }
    ) # findOne
    else
      res.status 400
      res.send { message: 'Don\'t just submit an empty form, brah' }
  ) # post

  app.post('/connect', isLoggedIn, (req, res) ->
    console.log util.inspect(req.body)
    IRCProxy.findOne( { _id: req.body.proxyId }, (err, proxy) ->
      if err
        res.status 404
        res.send { message: 'Couldn\'t find proxy, brah'}
      else
        res.send 200
    ) # proxy.findOne
  ) # post

isLoggedIn = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect('/')

handleError = (res, error) ->
  res.status 400
  res.send { message: error }
