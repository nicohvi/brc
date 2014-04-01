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
      res.status 401
      res.send { message: 'Don\'t just submit an empty form, brah' }
  )

isLoggedIn = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect('/')
