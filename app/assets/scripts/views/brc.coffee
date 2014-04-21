root = exports ? this

class BRCView

  constructor: (@events) ->
    @view = $('#irc')
    @connect = $('#connect')
    @initListeners()
    @initBindings()

  initListeners: =>
    @events.on '', () =>
      @view.append

  initBindings: =>
    @connect.on 'click', (event) =>
      $el = @connect
      @events.emit 'connectToIRC', $el.data('proxy-id')

root.BRCView = BRCView
