root = exports ? this

class HeaderView

  constructor: (@events) ->
    @view = $('header')
    @.initBindings()

  initBindings: ->
    $(@view).find('a').titleHover(20, 'left')

root.HeaderView = HeaderView
