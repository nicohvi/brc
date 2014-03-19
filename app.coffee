Server = require './server'
Database = require './db'
express = require 'express'
app = express()
port = process.env.PORT || 8000
passport = require 'passport'
flash = require 'connect-flash'
config = require './config/config'
nano = require('nano')(config.databaseUrl)

# use passport for auth
require('./config/passport')(passport)

# use nano for interfacing with couchDB
nano.db.create 'brc'
new Database(nano.use 'brc')

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

# set up the database

# routes
require('./config/routes')(app, passport)

# load the controllers
# require('./lib/init')(app, {})

# start the server
Server.start(app, port, ->
    console.log "Express server listening on port #{port}"
  )
