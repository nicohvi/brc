class Database
  @database

  constructor: (database) ->
    Database.database = database

  # @deleteAllUsers: ->
  #   @database.view('users', 'delete', (error, body) ->
  #       if error
  #         showError(error)
  #       else
  #         # iterate over all users and delete them
  #         body.rows.forEach (document) ->
  #           document._deleted = true
  #           document._rev = document.value
  #           document._id = document.id
  #
  #         @database.bulk( { docs : body.rows }, (error, body) ->
  #           if error? then console.log error else console.log body
  #         )
  #       )

  @find: (email, callback) ->
    @database.view('users', 'all', { email: email }, (error, document) ->
      if error then callback(error, null)
      else callback(null, document)
    )

  @save: (user, callback) ->
    @database.insert( { type: 'user', email: user.email, password: user.password, _id: user.uuid  } , (error, user) ->
      return callback(error, null) if error
      callback(null, user)
    )



module.exports = Database
