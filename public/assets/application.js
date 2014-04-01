(function() {
  $(function() {
    return $('.alert').on('click', function(event) {
      $(this).html('');
      return $(this).addClass('hidden');
    });
  });

}).call(this);

(function() {
  $(function() {
    return $('form#irc-config .confirm ').on('click', function(event) {
      var $form, options;
      $form = $(this).parents('form');
      options = {
        url: $form.attr('action'),
        method: 'POST',
        data: $form.find('input').val(),
        error: function(error) {
          return $form.find('.alert').removeClass('hidden').html(error.message);
        }
      };
      return $.ajax(options).done(function(data) {}).fail(function(jqXHR) {
        return options.error(jqXHR.responseJSON);
      });
    });
  });

}).call(this);
