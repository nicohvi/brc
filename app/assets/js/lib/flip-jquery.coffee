$.fn.flip = (callback) ->


  if $(@).find('.back').hasClass('hidden')
    $(@).find('.front').addClass('hidden')
    callback = =>
      callback2 = =>
        $(@).find('.back').removeClass('hidden')
      $(@).toggleClass('flipped')
      setTimeout(callback2, 800)
  else
    $(@).find('.back').addClass('hidden')
    callback = =>
      $(@).toggleClass('flipped')
      callback2 = =>
        $(@).find('.front').removeClass('hidden')
      setTimeout(callback2, 800)


  setTimeout(callback, 400)
