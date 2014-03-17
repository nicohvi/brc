passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
User = require '../app/models/user'

passport.use(new LocalStrategy(
  {usernameField: 'email', passwordField: 'password'},
  (email, password, done) ->
    User.find({email: email}, (error, user) ->
      if error then return done(error)
      unless user? then return done(null, false, { message: 'Incorrect email.' })
      unless user.valid then return done(null, false, { message: 'Incorrect password.' })
      return done(null, user)
    )
))

module.exports = (app) ->
  app.use(passport.initialize())
  app.use(passport.session())
