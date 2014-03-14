database = require '../../utils/db'

class User

  constructor: (params) ->
    @email = params['email']
    @username = params['username']
    @password = params['password']
    @uuid = ''

  save: ->
    console.log "saving shit: #{@email}, #{@username}, #{@password}"
    database.insert({ email: @email, username: @username, password: @password }, @uuid, (error, body) ->
                      if error
                        console.log "error while trying to save model: #{error}"
                      else
                        # uuid generated by couchDB
                        @uuid = body.id
                        console.log "saved model to database: #{body}")

  destroy: ->
    database.destroy(@uuid, '', (error, body) ->
      if error
        console.log "error while trying to destroy model: #{error}"
      else
        console.log body)


module.exports = User
