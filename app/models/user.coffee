database = require '../../utils/db'
util = require 'util'

class User

  constructor: (params) ->
    console.log "params: #{util.inspect(params)}"
    @email = params['email'].trim()
    @password = params['password']
    @uuid = params['uuid'] || new Buffer(@email).toString('base64')

  save: ->
    database.insert({ type: 'user', email: @email, password: @password, _id: @uuid }, (error, response) ->
                      if error
                        console.log "error while trying to save model: #{error}"
                      else
                        console.log "Document saved. email for key: #{new Buffer(response.id, 'base64').toString('ascii')}"
                    )

  @find: (options, callback) ->
    database.view('users', 'all', { email: options['email'] }, (error, document) ->
      if error
        console.log "error occured trying to find model with email: #{options['email']} - #{util.inspect(error)}"
        if callback? then callback(error, null)
      else
        console.log "Document found: #{util.inspect(document)}"
        if callback? then callback(null, new User(document.rows[0].value))
    )

  valid: (password) ->
    return @password == password

  # destroy: ->
    # find the document
    # database.get(@uuid, '', (error, body)) ->

    # delete the document
    # database.destroy(@uuid, '', (error, body) ->
      # if error
        # console.log "error while trying to destroy model: #{error}"
      # else
        # console.log body)


module.exports = User
