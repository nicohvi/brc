$.fn.titleHover = (offset, position) ->
  if $('#hoverBox').length > 0 then $hoverBox = $('#hoverBox')
  else $hoverBox = $('<div id="hoverBox"></div>').appendTo('body')

  mouseEnter = =>
    $this = $(@)
    $hoverBox.html $this.data('title')
    switch position
      when 'left'
        $hoverBox.css {
          'left': "#{$this.offset().left-($hoverBox.width()+offset)}px",
          'top': "#{$this.offset().top}px"
        }
        $this.css 'margin-left', $hoverBox.width()+offset
      when 'right'
        $hoverBox.css {
          'left': "#{$this.offset().left+offset}px",
          'top': "#{$this.offset().top}px"
        }
        $this.css 'margin-right', $hoverBox.width()+offset
    callback = -> $hoverBox.fadeIn()
    setTimeout callback, 300

  mouseLeave = =>
    $(@).css 'margin', 0
    $hoverBox.fadeOut 'fast', -> $(@).clearQueue()

  $(@).hover(
    -> mouseEnter()
    -> mouseLeave()
  )
