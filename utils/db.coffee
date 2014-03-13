config = require './config'
nano = require('nano')(config.database.url)

# create a new database if no one exists
database = nano.use('brc') || nano.create('brc')

exports.module = database
