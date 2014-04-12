$.fn.titleHover = ->
  if $('#hoverBox').length > 0 then $hoverBox = $('#hoverBox')
  else $hoverBox = $('<div id="hoverBox"></div>').appendTo('body')

  mouseEnter = =>
    $hoverBox.css {
      'left': "#{$(@).offset().left+50}px",
      'top': "#{$(@).offset().top}px"
    }
    $hoverBox.html $(@).data('title')
    $hoverBox.fadeIn()

  mouseLeave = =>
    $hoverBox.fadeOut 'fast', -> $(@).clearQueue()

  $(@).hover(
    -> mouseEnter()
    -> mouseLeave()
  )
