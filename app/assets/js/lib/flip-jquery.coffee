$.fn.flip = () ->
  
  if $(@).find('.back').hasClass('hidden')
    $(@).find('.front').addClass('hidden')
    callback = =>
      $(@).toggleClass('flipped')
      callback2 = =>
        $(@).find('.front').toggleClass('unflex')
        $(@).find('.back').removeClass('hidden unflex')
      setTimeout(callback2, 800)
  else
    $(@).find('.back').addClass('hidden')
    callback = =>
      $(@).toggleClass('flipped')
      callback2 = =>
        $(@).find('.back').toggleClass('unflex')
        $(@).find('.front').removeClass('hidden unflex')
      setTimeout(callback2, 800)

  setTimeout(callback, 400)
