module.exports = (port) ->
  express = require 'express'
  app = express()
  port = port || 8000
  passport = require 'passport'
  flash = require 'connect-flash'
  config = require './config/config'
  mongoose = require 'mongoose'

  # use passport for auth
  require('./config/passport')(passport)

  # mongoDB 4life
  mongoose.connect config.databaseURL

  app.configure ->
    # use jade for view templates
    app.set('view engine', 'jade')
    app.set('views', "#{__dirname}/app/views")

    # TODO: use winston for logging
    app.use express.logger('dev')

    # set environment variables
    app.use express.static("#{__dirname}/app/assets")
    app.use express.cookieParser()
    app.use express.bodyParser()
    app.use express.session({ secret: 'troll dog' })

    app.use passport.initialize()
    app.use passport.session()
    app.use flash()

  # routes
  require('./config/routes')(app, passport)

  # start the server
  app.listen port, console.log "Express server listening on port #{port}"
