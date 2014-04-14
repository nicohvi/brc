root = exports ? this

class Application

  constructor: () ->
    @eventEmitter = new EventEmitter()
    @views = []
    @views.push new HomeView @eventEmitter
    @views.push new HeaderView @eventEmitter
    @views.push new BRCView @eventEmitter

class App

  instance = null

  @get: ->
    instance ?= new Application()

root.App = App
