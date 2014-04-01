User = require '../app/models/user'
IRCProxy = require '../app/models/irc-proxy'

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
    res.render('home.jade', { user: req.user })
  )

  app.post('/irc-config', isLoggedIn, (req, res) ->
    unless req.body.nick
      res.status 400
      res.send { message: 'Don\'t just submit an empty form, brah' }

    user = User.findOne({ email: req.user.email }, (error, user) ->
      throw error if error
      ircProxy = new IRCProxy { _user: user._id, nick: req.body.nick }
      ircProxy.save (error, proxy) ->
        throw error if error
        res.send { message: 'Proxy created', proxy: proxy }
    ) # findOne

  )

isLoggedIn = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect('/')
