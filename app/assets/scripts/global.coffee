$ ->

  $('.alert').on 'click', (event) ->
    $(@).html('')
    $(@).addClass('hidden')
