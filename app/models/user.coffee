Database = require '../../db'
bcrypt = require 'bcrypt-nodejs'
util = require 'util'

class User

  constructor: (params) ->
    @email = params['email']
    @password = params['password']
    @uuid = params['uuid'] || new Buffer(@email).toString('base64')
    @type = 'user'
    console.log "user constructed: email - #{@email},
                password - #{@password}, uuid - #{@uuid}"

  @findByEmail: (email, callback) ->
    Database.find(email, (error, document) ->
      if error
        console.log "error occured trying to find model with email: #{options['email']} - #{util.inspect(error)}"
        callback(error, null)
      else
        return callback(null, false) unless document.total_rows > 0  # no users found
        console.log "Document found: #{util.inspect(document)}"
        callback(null, new User(document.rows[0].value))
    )

  valid: (passwordHash) ->
    bcrypt.compareSync(@password, passwordHash)

  hashPassword: ->
    salt = bcrypt.genSaltSync(10)
    @password = bcrypt.hashSync(@password, salt)

  save: (callback) ->
    @.hashPassword()
    Database.save(@, (error, user) ->
      if error
        console.log "error while trying to save model: #{error}"
        callback(error, null)
      else
        console.log "Document saved. email for key: #{new Buffer(user.id, 'base64').toString('ascii')}"
        callback(null, error)
    )

module.exports = User
