(function() {
  var App, Application, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  Application = (function() {
    function Application() {
      this.eventEmitter = new EventEmitter();
      this.views = [];
      this.views.push(new HomeView(this.eventEmitter));
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


}).call(this);

(function() {


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
          return _this.updateView(response);
        };
      })(this));
      this.events.addListener("irc_proxy:submit:error", (function(_this) {
        return function(error) {
          return _this.updateView(error);
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
      return this.form.find('.confirm').on('click', (function(_this) {
        return function(event) {
          return _this.submitForm();
        };
      })(this));
    };

    HomeView.prototype.updateView = function(data) {
      debugger;
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
          return _this.events.emit("irc_proxy:submit:error", jqXHR);
        };
      })(this));
    };

    return HomeView;

  })();

  root.HomeView = HomeView;

}).call(this);
