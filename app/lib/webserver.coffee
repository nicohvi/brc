express = require 'express'
path = require 'path'
# websocket = require './config/websocket'
http = require 'http'
# port = port || 8000
# passport = require 'passport'
# flash = require 'connect-flash'
# RedisStore = require('connect-redis')(express)
config = require '../../config'
# stylus = require 'stylus'

app = exports.app = express()
server = exports.server = http.createServer(app)

app.configure ->
  root = path.join __dirname, '..'
  console.log "#{root}"
  app.use require('connect-assets')( { src: "#{root}/assets" } )
  app.use '/assets', express.static "#{root}/assets"
  app.use '/img', express.static "#{root}/assets/images"
  app.set 'views', "#{root}/views"

  # use jade for view templates
  # app.set('view engine', 'jade')
  # app.set('views', "#{__dirname}/app/views")

  # TODO: use winston for logging
  app.use express.logger('dev')

  # set environment variables
  # app.use express.cookieParser()
  # app.use express.bodyParser()

  # use redis for session persistance to keep user logged in between
  # app restarts.
  # app.use express.session {
  #   secret: config.secret_key
  #   store: new RedisStore {
  #     host: config.redis.host,
  #     port: config.redis.port,
  #     user: config.redis.username,
  #     pass: config.redis.password
  #   },
  #   cookie: {
  #     maxAge: 604800 # one week
  #   }
  # }

  # app.use passport.initialize()
  # app.use passport.session()

# setup application environments
configureApp = (app, config) ->
  # set environment variables
  app.set('port', config.port)

app.configure 'development', ->
  envConfig = config.dev
  configureApp(app, envConfig)

app.configure 'production', ->
  envConfig = config.prod
  configureApp(app, envConfig)

port = app.get 'port'
server.listen(port)

app.get '/', (req, res) ->
  res.render 'index.jade'

# set up database
# global.db = mongoose.createConnection("#{config.databaseURL}/#{env}")

# use passport for auth
# require('./config/passport')(passport)

# routes
# require('./app/routes/routes')(app, passport)

# start the server
# server = http.createServer(app).listen port, console.log "Express server listening on port #{port}"

# start the websocket server
# websocket.startSocketServer(server)

# return the server instance
# server
