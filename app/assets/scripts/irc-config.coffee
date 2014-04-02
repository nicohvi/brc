# $ ->
#
#   $('#irc-config').on 'submit', (event) ->
#     event.preventDefault()
#
#   $('form#irc-config').on 'keydown', (event) ->
#     submitForm $(@) if event.keyCode == 13
#
#   $('form#irc-config .confirm ').on 'click', (event) ->
#     submitForm $(@).parents 'form'
#
#   submitForm = ($form) ->
#     data = $form.find('input').serialize()
#
#     options =
#       url:    $form.attr('action')
#       method: 'POST'
#       data:   data
#       error:  (error) ->
#         $form.find('.alert').removeClass('hidden').html(error.message)
#
#     $.ajax(options)
#       .done( (data) ->
#         clearErrors()
#
#         $('.irc-nick').html(data.proxy.nick)
#       )
#       .fail( (jqXHR) ->
#         options.error(jqXHR.responseJSON)
#       )
