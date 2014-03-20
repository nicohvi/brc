LocalStrategy = require('passport-local').Strategy
User = require '../app/models/user'
util = require 'util'

module.exports = (passport) ->

  passport.serializeUser (user, done) ->
    done(null, user.id)

  passport.deserializeUser (id, done) ->
    User.findById(id, (error, user) ->
      done(error, user)
    )

  # two local strategies: one for signing up, one for logging in.

  # signup-strategy
  passport.use('local-signup', new LocalStrategy {
      usernameField: 'email',
      passwordField: 'password',
      passReqToCallback: true
    },
    (req, email, password, done) ->
      # ensures that User.findByEmail is not fired unless
      # data is returned from the router.
      process.nextTick ->
        User.findOne({ email: email }, (error, user) ->
          return done(error, null, req.flash('signupMessage', error)) if error
          return done(null, false, req.flash('signupMessage', 'That email is already taken.')) if user

          # all is well, create the new user.
          user = new User({ email: email, password: password })
          user.save((error) ->
            throw error if error
            done(null, user)
          ) # save
        ) # findByEmail
  ) # passport.use


  #login-strategy
  passport.use('local-login', new LocalStrategy {
      usernameField: 'email',
      passwordField: 'password',
      passReqToCallback: true
    },
    (req, email, password, done) ->
      User.findOne({ email: email }, (error, user) ->
        return done(error, null, req.flash('loginMessage', error)) if error
        return done(null, false, req.flash('loginMessage', 'Incorrect email address.')) unless user?
        return done(null, false, req.flash('loginMessage', 'Wrong password, brah.')) unless user.validPassword(password)
        # all is well
        return done(null, user)
      ) #findByEmail
  ) # passport.use
