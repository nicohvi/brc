(function() {
  var App, Application, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  Application = (function() {
    function Application() {
      this.events = new EventEmitter();
      this.views = [new HomeView(this.events, new HeaderView(this.events, new BRCView(this.events)))];
      this.controllers = [new WebsocketController(this.events, new ChannelController(this.events))];
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
  var ChannelController, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  ChannelController = (function() {
    function ChannelController(events) {
      this.events = events;
      this.initListeners = __bind(this.initListeners, this);
      this.initListeners();
      this.channels = [];
    }

    ChannelController.prototype.initListeners = function() {
      this.events.on('add_channel', (function(_this) {
        return function(channel) {
          return _this.channels.push(new Channel(channel, _this.events, {}));
        };
      })(this));
      return this.events.on('message', (function(_this) {
        return function(message) {
          var channel;
          channel = _this.channels.filter(function(_channel) {
            return _channel.name === message.to;
          }).pop();
          console.log("channel: " + (JSON.stringify(channel)));
          if (channel == null) {
            _this.channels.push(new Channel(message.to, _this.events, {}));
          }
          return _this.events.emit('add_message', channel);
        };
      })(this));
    };

    return ChannelController;

  })();

  root.ChannelController = ChannelController;

}).call(this);

(function() {
  var WebsocketController, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  WebsocketController = (function() {
    function WebsocketController(events) {
      this.events = events;
      this.emit = __bind(this.emit, this);
      this.connect = __bind(this.connect, this);
      this.initListeners = __bind(this.initListeners, this);
      this.url = 'localhost';
      this.initListeners();
      console.log("websocket-controller created with url: " + this.url);
    }

    WebsocketController.prototype.initListeners = function() {
      return this.events.on('connectToIRC', (function(_this) {
        return function(proxyId) {
          return _this.connect(function() {
            return _this.emit('connectToIRC', {
              proxyId: proxyId
            });
          });
        };
      })(this));
    };

    WebsocketController.prototype.connect = function(done) {
      this.socket = io.connect(this.url);
      this.socket.on('message', (function(_this) {
        return function(message) {
          console.log("client received " + (JSON.stringify(message)));
          return _this.events.emit('message', message);
        };
      })(this));
      this.socket.on('registered', (function(_this) {
        return function(user) {
          User.get();
          return _this.events.emit('add_channel', '#status');
        };
      })(this));
      this.socket.on('close', (function(_this) {
        return function() {};
      })(this));
      return done();
    };

    WebsocketController.prototype.emit = function(command, data) {
      console.log("emitting: " + command);
      return this.socket.emit(command, data);
    };

    return WebsocketController;

  })();

  root.WebsocketController = WebsocketController;

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
          return $hoverBox.fadeIn('fast');
        };
        return _this.timeout = setTimeout(callback, 300);
      };
    })(this);
    mouseLeave = (function(_this) {
      return function() {
        clearTimeout(_this.timeout);
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
  var Channel, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  Channel = (function() {
    function Channel(name, events, opts) {
      this.name = name;
      this.events = events;
      this.toString = __bind(this.toString, this);
      this.updateView = __bind(this.updateView, this);
      this.addMessage = __bind(this.addMessage, this);
      this.mode = opts.mode;
      this.topic = opts.topic;
      this.history = [];
      this.updateView();
    }

    Channel.prototype.addMessage = function(message) {
      this.history.push(message);
      return this.updateView();
    };

    Channel.prototype.updateView = function() {
      console.log("name: " + this.name);
      console.log("tostring: " + (JSON.stringify(this.toString())));
      console.log("self: " + (JSON.stringify(this)));
      return $('#irc').html(templatizer.channel(this.toString()));
    };

    Channel.prototype.toString = function() {
      return {
        channel: {
          name: this.name
        }
      };
    };

    return Channel;

  })();

  root.Channel = Channel;

}).call(this);

(function() {
  var User, UserSingleton, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  UserSingleton = (function() {
    function UserSingleton(nick, events) {
      this.nick = nick;
      this.events = events;
      this.channels = [];
    }

    return UserSingleton;

  })();

  User = (function() {
    var instance;

    function User() {}

    instance = null;

    User.get = function() {
      return instance != null ? instance : instance = new User();
    };

    return User;

  })();

  root.User = User;

}).call(this);

(function() {
  var BRCView, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  BRCView = (function() {
    function BRCView(events) {
      this.events = events;
      this.initBindings = __bind(this.initBindings, this);
      this.initListeners = __bind(this.initListeners, this);
      this.view = $('#irc');
      this.connect = $('#connect');
      this.initListeners();
      this.initBindings();
    }

    BRCView.prototype.initListeners = function() {
      return this.events.on('', (function(_this) {
        return function() {
          return _this.view.append;
        };
      })(this));
    };

    BRCView.prototype.initBindings = function() {
      return this.connect.on('click', (function(_this) {
        return function(event) {
          var $el;
          $el = _this.connect;
          return _this.events.emit('connectToIRC', $el.data('proxy-id'));
        };
      })(this));
    };

    return BRCView;

  })();

  root.BRCView = BRCView;

}).call(this);

(function() {
  var HeaderView, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  HeaderView = (function() {
    function HeaderView(events) {
      this.events = events;
      this.initBindings = __bind(this.initBindings, this);
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
  var HomeView, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  HomeView = (function() {
    function HomeView(events) {
      this.events = events;
      this.submitForm = __bind(this.submitForm, this);
      this.lockForm = __bind(this.lockForm, this);
      this.updateForm = __bind(this.updateForm, this);
      this.updateView = __bind(this.updateView, this);
      this.clearErrors = __bind(this.clearErrors, this);
      this.initBindings = __bind(this.initBindings, this);
      this.initListeners = __bind(this.initListeners, this);
      this.view = $('#content');
      this.form = $('#irc-config');
      this.connect = $('#connect');
      this.initListeners();
      this.initBindings();
    }

    HomeView.prototype.initListeners = function() {
      this.events.on('irc_proxy:submit:success', (function(_this) {
        return function(response) {
          _this.clearErrors();
          return _this.updateView(response);
        };
      })(this));
      return this.events.on('irc_proxy:submit:error', (function(_this) {
        return function(error) {
          return _this.showError(error);
        };
      })(this));
    };

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
      return $('input + .lock').on('click', function(event) {
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
          return _this.events.emit('irc_proxy:submit:success', data);
        };
      })(this)).fail((function(_this) {
        return function(jqXHR) {
          return _this.events.emit('irc_proxy:submit:error', jqXHR.responseJSON);
        };
      })(this));
    };

    return HomeView;

  })();

  root.HomeView = HomeView;

}).call(this);
