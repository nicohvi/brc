$ ->

  $('.alert').on 'click', (event) ->
    $(@).html('')
    $(@).addClass('hidden')

  window.clearErrors = ->
    $('.alert').html('')
    $('.alert').addClass('hidden')
