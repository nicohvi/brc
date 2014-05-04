Q = require 'q'
bcrypt = require 'bcrypt'
uuid = require 'node-uuid'
util = require 'util'
validator = require 'validator'

module.exports = (app) ->

  # User API
  User = app.db.models.brc_user
  findUser = Q.nfbind User.findOne.bind(User)
  createUser = Q.nfbind User.create.bind(User)

  #  encryption API
  encrypt = Q.nfbind bcrypt.genSalt
  hash = Q.nfbind bcrypt.hash

  app.get '/', (req, res) ->
    res.render 'index.jade'

  app.post '/login', (req, res) ->
    errors = validateParams(req.body)
    return res.json JSON.stringify(errors) if errors.length > 0

    findUser(
      where:
        username: req.body.username
    ).then(
      (user) ->
        return res.json 'success' if user?
        res.json 'success - but no user, bro.'
      ,
      (error) ->
        res.json 'Error.'
    ).done()

  app.post '/signup', (req, res) ->
    errors = validateParams(req.body)
    return res.json JSON.stringify(errors) if errors.length > 0

    findUser(
      where:
        username: req.body.username
    )
    .then(
      (user) ->
        console.log "Tried to find user: #{util.inspect(user)}"
        throw new Error('message': 'Username/email already exists.') if user
        encrypt(10)
    )
    .then(
      (salt) ->
        console.log "Salt created: #{util.inspect(salt)}"
        hash(req.body.password, salt)
    )
    .then(
      (hash) ->
        console.log "hash created: #{util.inspect(hash)}"
        createUser(
          user_id: uuid.v1(),
          username: req.body.username,
          password: hash,
          joined: Date.now()
        )
    )
    .then(
      (user) ->
        console.log "create user returned with user: #{util.inspect(user)}"
        JSON.stringify(user)
    )
    .fail(
      (error) ->
        console.log "Error handler called: #{util.inspect(error)}"
        JSON.stringify(error)
    )
    .done(
      (json) ->
        res.json json
    )

  validateParams = (params) ->
    errors = []
    for name, value of params
      console.log "name: #{name}, value: #{value}"
      unless value.length > 0
        errors.push 'message': 'Don\'t just submit an empty form, brah.'
        break
      if name == 'username' && !validator.isEmail(value)
        errors.push 'message': 'Invalid email, brah.'
        break
    errors
