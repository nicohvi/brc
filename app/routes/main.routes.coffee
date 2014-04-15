User = require '../models/user'
util = require 'util'
_ = require 'underscore'

module.exports = (app, passport) ->

  app.get('/', (req, res) ->
    if req.user then res.redirect('/home')
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
    passport.authenticate('local-login',
      { badRequestMessage: 'You forgot to type stuff in the boxes, brah.' },
      (error, user, info) ->
        return next(error) if error
        if(!user)
          req.flash('loginMessage', info.message)
          return res.redirect('/')
        req.logIn(user, (error) ->
          return next(error) if error
          req.flash('message', 'You have totally logged in.')
          if req.body.rememberme
            req.session.cookie.maxAge = 2592000000 # one month
          else
            req.session.expires = false
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
        console.log "proxy: #{util.inspect proxy}"
        res.render 'home.jade', { user: user, proxy: proxy, message: req.flash 'message' }
      ) # getIrcProxy
    ) # findOne
  )

isLoggedIn = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect('/')

handleError = (res, error) ->
  res.status 400
  res.send { message: error }
