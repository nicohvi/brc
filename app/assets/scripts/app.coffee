root = exports ? this

class Application

  constructor: () ->
    @eventEmitter = new EventEmitter()
    @views = []
    @views.push new HomeView @eventEmitter
    @views.push new HeaderView @eventEmitter

class App

  instance = null

  @get: ->
    instance ?= new Application()

root.App = App
