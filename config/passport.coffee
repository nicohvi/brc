# passport = require 'passport'
# LocalStrategy = require('passport-local').Strategy
# User = require '../app/models/user'
#
# passport.use(new LocalStrategy(
#   {usernameField: 'email', passwordField: 'password'},
#   (email, password, done) ->
#     User.find({email: email}, (error, user) ->
#       if error then return done(error)
#       unless user? then return done(null, false, { message: 'Incorrect email.' })
#       unless user.valid then return done(null, false, { message: 'Incorrect password.' })
#       return done(null, user)
#     )
# ))
#
# module.exports = (app) ->
#   app.use(passport.initialize())
#   app.use(passport.session())

LocalStrategy = require('passport-local').Strategy
User = require '../app/models/user'

module.exports = (passport) ->

  passport.serializeUser (user, done) ->
    done(null, user)

  passport.deserializeUser (email, done) ->
    User.findByEmail(email, (error, user) ->
      done(error, user)
    )

  # two local strategies: one for signing up, one for logging in.
  passport.use('local-signup', new LocalStrategy {
      usernameField: 'email',
      passwordField: 'password',
      passReqToCallback: true
    },
    (req, email, password, done) ->
      # todo: WTF is this
      process.nextTick ->
        User.findByEmail(email, (error, user) ->
          return done(error, false, req.flash('signupMessage', error)) if error

          return done(null, false, req.flash('signupMessage', 'That email is already taken')) if user

          user = new User { email: email, password: password }
          user.save((error) ->
            throw error if error
            done(null, user)
          ) # save
        ) # findByEmail
  ) # passport.use
