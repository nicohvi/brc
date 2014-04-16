module.exports = (port, env) ->
  express = require 'express'
  websocket = require './config/websocket'
  http = require 'http'
  mongoose = require 'mongoose'
  app = express()
  port = port || 8000
  passport = require 'passport'
  flash = require 'connect-flash'
  RedisStore = require('connect-redis')(express)
  config = require './config/config'
  stylus = require 'stylus'

  # set application environment
  env = env || 'dev'

  # set up database
  global.db = mongoose.createConnection("#{config.databaseURL}/#{env}")

  # use passport for auth
  require('./config/passport')(passport)

  app.configure ->
    # use jade for view templates
    app.set('view engine', 'jade')
    app.set('views', "#{__dirname}/app/views")

    # TODO: use winston for logging
    app.use express.logger('dev')

    # set environment variables
    app.use express.cookieParser()
    app.use express.bodyParser()

    # use redis for session persistance to keep user logged in between
    # app restarts.
    app.use express.session {
      secret: 'troll dog',
      store: new RedisStore {
        host: config.redis.host,
        port: config.redis.port,
        user: config.redis.username,
        pass: config.redis.password
      },
      cookie: {
        maxAge: 604800 # one week
      }
    }

    app.use passport.initialize()
    app.use passport.session()
    app.use flash()
    app.set('env', env)

    # use stylus
    app.use stylus.middleware {
      src:   "#{__dirname}/app/assets/stylesheets",
      dest:  "#{__dirname}/public",
      debug: true,
      force: true
    }
    app.use express.static("#{__dirname}/public")

  # routes
  require('./app/routes/routes')(app, passport)

  # start the server
  server = http.createServer(app).listen port, console.log "Express server listening on port #{port}"

  # start the websocket server
  websocket.startSocketServer(server)

  # return the server instance
  server
