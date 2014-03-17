util = require 'util'
passport = require 'passport'

class MockStrategy

  constructor: (verify) ->
    @name = 'mock'
    @verify = verify

  util.inherits(MockStrategy, passport.Strategy)

  authenticate: (req) ->
    self = @
    verified = (error, user, info) ->
      self.success(user, info)

    @verify(verified)

module.exports = MockStrategy
