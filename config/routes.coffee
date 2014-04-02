User = require '../app/models/user'
util = require 'util'

module.exports = (app, passport) ->

  app.get('/', (req, res) ->
    res.render 'index.jade'
  )

  app.get('/signup', (req, res) ->
    res.render('signup.jade', { message: req.flash 'signupMessage' })
  )

  app.post('/signup', passport.authenticate('local-signup', {
        successRedirect: '/home',
        failureRedirect: '/signup'
        failureFlash: true
      }) # authenticate
  )

  app.get('/login', (req, res) ->
    res.render('login.jade', { message: req.flash 'loginMessage' })
  )

  app.post('/login', passport.authenticate('local-login', {
      successRedirect: '/home',
      failureRedirect: '/login',
      failureFlash: true
    }) # authenticate
  )

  app.get('/home', isLoggedIn, (req, res) ->
    User.findOne( { email: req.user.email }, (error, user) ->
      return handleError(res, error) if error
      user.getIrcProxy( (error, proxy) ->
        return handleError(res, error) if error
        res.render 'home.jade', { user: user, proxy: proxy }
      ) # getIrcProxy
    ) # findOne
  )

  app.post('/irc-config', isLoggedIn, (req, res) ->
    if req.body.nick? and not (req.body.nick == "")
      User.findOne( { email: req.user.email }, (error, user) ->
        user.getIrcProxy (error, proxy) ->
          return handleError(res, error) if error
          if proxy?
            proxy.nick = req.body.nick
            proxy.save (error) ->
              return handleError(res, error) if error
              res.send { message: 'Proxy updated.', proxy: proxy }
          else
            user.createProxy (error, proxy) ->
              return handleError(res, error) if error
              proxy.nick = req.body.nick
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
