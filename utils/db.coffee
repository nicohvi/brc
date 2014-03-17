config = require './config'
nano = require('nano')(config.database.url)

# create a new database if no one exists
nano.db.create('brc')

database = nano.db.use('brc')

database.deleteAllUsers = ->
  @.view('users', 'delete', (error, body) ->
    if error
      showError(error)
    else
      # iterate over all users and delete them
      body.rows.forEach (document) ->
        document._deleted = true
        document._rev = document.value
        document._id = document.id

      database.bulk( { docs : body.rows }, (error, body) ->
        if error? then showError(error) else console.log body
      )
    )

showError = (error) ->
  console.log "Error occured sitting on couch: #{error}"

module.exports = database
