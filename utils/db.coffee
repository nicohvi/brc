config = require 'config'
nano = require('nano')(config.database.url)
