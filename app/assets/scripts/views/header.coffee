root = exports ? this

class HeaderView

  constructor: (@events) ->
    @view = $('header')
    @.initBindings()

  initBindings: ->
    $(@view).find('a').titleHover()

root.HeaderView = HeaderView
