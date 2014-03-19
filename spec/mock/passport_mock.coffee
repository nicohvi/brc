User = require '../../app/models/user'
passport = require 'passport'
MockStrategy = require './mock_strategy'
util = require 'util'

mockUser = new User({ email: 'test@test.com', password: '123password' })

verify = (done) ->
  done(null, mockUser)

module.exports.mock = (app, options) ->
  passport.use new MockStrategy(verify)
  passport.serializeUser( (user, done) -> done(null, user.email) )
  passport.deserializeUser( (id, done) -> done(null, mockUser) )

  app.get('/login!', passport.authenticate('mock'), (req, res) ->
    res.redirect('/')
  )
