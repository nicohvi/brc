$.fn.titleHover = (offset, position) ->
  if $('#hoverBox').length > 0 then $hoverBox = $('#hoverBox')
  else $hoverBox = $('<div id="hoverBox"></div>').appendTo('body')

  mouseEnter = =>
    $hoverBox.html $(@).data('title')
    switch position
      when 'left'
        $hoverBox.css {
          'left': "#{$(@).offset().left-($hoverBox.width()+offset)}px",
          'top': "#{$(@).offset().top}px"
        }
      when 'right'
        $hoverBox.css {
          'left': "#{$(@).offset().left+offset}px",
          'top': "#{$(@).offset().top}px"
        }
    $hoverBox.fadeIn()

  mouseLeave = =>
    $hoverBox.fadeOut 'fast', -> $(@).clearQueue()

  $(@).hover(
    -> mouseEnter()
    -> mouseLeave()
  )
