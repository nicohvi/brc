$ ->

  $('form#irc-config .confirm ').on 'click', (event) ->
    $form = $(@).parents('form')
    options =
      url:   $form.attr('action')
      method: 'POST'
      data:  $form.find('input').val()
      error: (error) ->
        $form.find('.alert').removeClass('hidden').html(error.message)

    $.ajax(options)
      .done( (data) ->
        $for
      )
      .fail( (jqXHR) ->
        options.error(jqXHR.responseJSON)
      )
