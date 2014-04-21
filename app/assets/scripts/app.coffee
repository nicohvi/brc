root = exports ? this

class Application

  constructor: ->
    @events = new EventEmitter()
    @views =
      [
        new HomeView @events,
        new HeaderView @events,
        new BRCView @events
      ]
    @controllers =
      [
        new WebsocketController @events,
        new ChannelController @events
      ]
      

class App

  instance = null

  @get: ->
    instance ?= new Application()




root.App = App
