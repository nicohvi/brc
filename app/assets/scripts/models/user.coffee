root = exports ? this

class UserSingleton

  constructor: (@nick, @events)->
    @channels = []

class User

  instance = null

  @get: ->
    instance ?= new User()

root.User = User
