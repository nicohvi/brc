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

  # app.post('/login', (req, res) ->
    # passport stuff
  # )

  app.get('/home', isLoggedIn, (req, res) ->
    res.render('home.jade', { user: req.user })
  )

isLoggedIn = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect('/')
