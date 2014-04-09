User = require '../app/models/user'
util = require 'util'

module.exports = (app, passport) ->

  app.get('/', (req, res) ->
    res.render 'index.jade', { message: req.flash 'loginMessage' }
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

  app.post('/login', (req, res, next) ->
    passport.authenticate('local-login', (error, user, info) ->
      return next(error) if error
      if(!user)
        info.message = 'You forgot to type stuff in the boxes, brah.' if info.message == 'Missing credentials'
        req.flash('loginMessage', info.message)
        return res.redirect('/')
      req.logIn(user, (error) ->
        return next(error) if error
        req.flash('message', 'Logged in.')
        return res.redirect('/home')
      ) #logIn
    )(req, res, next)
  )

  app.get('/logout', (req, res) ->
    req.session.destroy(
      res.redirect '/'
    )
  )

  app.get('/home', isLoggedIn, (req, res) ->
    User.findOne( { email: req.user.email }, (error, user) ->
      return handleError(res, error) if error
      user.getIrcProxy( (error, proxy) ->
        return handleError(res, error) if error
        res.render 'home.jade', { user: user, proxy: proxy, message: req.flash 'message' }
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
            proxy.servers = req.body.servers
            proxy.save (error) ->
              return handleError(res, error) if error
              res.send { message: 'Proxy updated.', proxy: proxy }
          else
            user.createProxy (error, proxy) ->
              return handleError(res, error) if error
              proxy.nick = req.body.nick
              proxy.servers = req.body.servers
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
