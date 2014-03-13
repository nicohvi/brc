config = require './config'
nano = require('nano')(config.database.url)

# create a new database if no one exists
nano.db.create('brc')

database = nano.db.use('brc') 

module.exports = database
