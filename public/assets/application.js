(function() {
  $(function() {
    $('.alert').on('click', function(event) {
      $(this).html('');
      return $(this).addClass('hidden');
    });
    return window.clearErrors = function() {
      $('.alert').html('');
      return $('.alert').addClass('hidden');
    };
  });

}).call(this);

(function() {
  $(function() {
    var submitForm;
    $('#irc-config').on('submit', function(event) {
      return event.preventDefault();
    });
    $('form#irc-config').on('keydown', function(event) {
      if (event.keyCode === 13) {
        return submitForm($(this));
      }
    });
    $('form#irc-config .confirm ').on('click', function(event) {
      return submitForm($(this).parents('form'));
    });
    return submitForm = function($form) {
      var data, options;
      data = $form.find('input').serialize();
      options = {
        url: $form.attr('action'),
        method: 'POST',
        data: data,
        error: function(error) {
          return $form.find('.alert').removeClass('hidden').html(error.message);
        }
      };
      return $.ajax(options).done(function(data) {
        clearErrors();
        return $('.irc-nick').html(data.proxy.nick);
      }).fail(function(jqXHR) {
        return options.error(jqXHR.responseJSON);
      });
    };
  });

}).call(this);
