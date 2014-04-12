(function() {
  var App, Application, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  Application = (function() {
    function Application() {
      this.eventEmitter = new EventEmitter();
      this.views = [];
      this.views.push(new HomeView(this.eventEmitter));
      this.views.push(new HeaderView(this.eventEmitter));
    }

    return Application;

  })();

  App = (function() {
    var instance;

    function App() {}

    instance = null;

    App.get = function() {
      return instance != null ? instance : instance = new Application();
    };

    return App;

  })();

  root.App = App;

}).call(this);

(function() {
  $(function() {
    return App.get();
  });

}).call(this);

(function() {
  $.fn.titleHover = function(offset, position) {
    var $hoverBox, mouseEnter, mouseLeave;
    if ($('#hoverBox').length > 0) {
      $hoverBox = $('#hoverBox');
    } else {
      $hoverBox = $('<div id="hoverBox"></div>').appendTo('body');
    }
    mouseEnter = (function(_this) {
      return function() {
        var $this, callback;
        $this = $(_this);
        $hoverBox.html($this.data('title'));
        switch (position) {
          case 'left':
            $hoverBox.css({
              'left': "" + ($this.offset().left - ($hoverBox.width() + offset)) + "px",
              'top': "" + ($this.offset().top) + "px"
            });
            $this.css('margin-left', $hoverBox.width() + offset);
            break;
          case 'right':
            $hoverBox.css({
              'left': "" + ($this.offset().left + offset) + "px",
              'top': "" + ($this.offset().top) + "px"
            });
            $this.css('margin-right', $hoverBox.width() + offset);
        }
        callback = function() {
          return $hoverBox.fadeIn();
        };
        return setTimeout(callback, 300);
      };
    })(this);
    mouseLeave = (function(_this) {
      return function() {
        $(_this).css('margin', 0);
        return $hoverBox.fadeOut('fast', function() {
          return $(this).clearQueue();
        });
      };
    })(this);
    return $(this).hover(function() {
      return mouseEnter();
    }, function() {
      return mouseLeave();
    });
  };

}).call(this);

(function() {
  var HeaderView, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  HeaderView = (function() {
    function HeaderView(events) {
      this.events = events;
      this.view = $('header');
      this.initBindings();
    }

    HeaderView.prototype.initBindings = function() {
      return $(this.view).find('a').titleHover(20, 'left');
    };

    return HeaderView;

  })();

  root.HeaderView = HeaderView;

}).call(this);

(function() {
  var HomeView, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  HomeView = (function() {
    function HomeView(events) {
      this.events = events;
      this.view = $('#content');
      this.form = $('#irc-config');
      this.events.addListener("irc_proxy:submit:success", (function(_this) {
        return function(response) {
          _this.clearErrors();
          return _this.updateView(response);
        };
      })(this));
      this.events.addListener("irc_proxy:submit:error", (function(_this) {
        return function(error) {
          return _this.showError(error);
        };
      })(this));
      this.initBindings();
    }

    HomeView.prototype.initBindings = function() {
      this.form.on('submit', (function(_this) {
        return function(event) {
          return event.preventDefault();
        };
      })(this));
      this.form.on('keydown', (function(_this) {
        return function(event) {
          if (event.keyCode === 13) {
            return _this.submitForm();
          }
        };
      })(this));
      this.form.find('.confirm').on('click', (function(_this) {
        return function(event) {
          return _this.submitForm();
        };
      })(this));
      $('.message').on('click', function(event) {
        return $(this).html('').addClass('hidden');
      });
      return $('input[name=nick] + .lock').on('click', function(event) {
        var $input;
        $input = $(this).prev();
        $input.attr('disabled', function(idx, oldAttr) {
          return !oldAttr;
        });
        $(this).find('i').toggleClass('fa-lock fa-unlock-alt');
        if (!$input.attr('disabled')) {
          return $input.focus();
        }
      });
    };

    HomeView.prototype.showError = function(error) {
      return this.form.find('.message').addClass('alert').removeClass('hidden').html(error.message);
    };

    HomeView.prototype.clearErrors = function() {
      return this.form.find('.message').html('').removeClass('alert').addClass('hidden');
    };

    HomeView.prototype.updateView = function(data) {
      this.form.find('.message').addClass('notice').removeClass('hidden').html(data.message);
      this.updateForm(data.proxy);
      return this.lockForm();
    };

    HomeView.prototype.updateForm = function(proxy) {
      var key, value, _results;
      _results = [];
      for (key in proxy) {
        value = proxy[key];
        _results.push($("input[name=" + key + "]").val(value));
      }
      return _results;
    };

    HomeView.prototype.lockForm = function() {
      return _.each($('.lock'), function(element, index) {
        $(element).find('i').removeClass('fa-unlock-alt').addClass('fa-lock');
        return $(element).prev().attr('disabled', true);
      });
    };

    HomeView.prototype.submitForm = function() {
      var data, options;
      data = this.form.find('input').serialize();
      options = {
        url: this.form.attr('action'),
        method: 'POST',
        data: data
      };
      return $.ajax(options).done((function(_this) {
        return function(data) {
          return _this.events.emit("irc_proxy:submit:success", data);
        };
      })(this)).fail((function(_this) {
        return function(jqXHR) {
          return _this.events.emit("irc_proxy:submit:error", jqXHR.responseJSON);
        };
      })(this));
    };

    return HomeView;

  })();

  root.HomeView = HomeView;

}).call(this);
