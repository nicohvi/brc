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
  compare = Q.nfbind bcrypt.compare

  app.get '/', (req, res) ->
    res.render 'index.jade'

  app.post '/login', (req, res) ->
    error = validateParams(req.body)
    return res.json JSON.stringify(error) if error?

    findUser(
      where:
        username: req.body.username
    )
    .then(
      (user) ->
        throw new Error('Couldn\'t find a user with that email') unless user?
        compare(req.body.password, user.password)
        .then(
          (result) ->
            throw new Error('Wrong password, brah.') unless result
            res.json JSON.stringify('user': user)
        )
    )
    .fail(
      (error) ->
        res.json JSON.stringify('error': 'message': error.message)
    )
    .done()

  app.post '/signup', (req, res) ->
    error = validateParams(req.body)
    return res.json JSON.stringify(error) if error?

    findUser(
      where:
        username: req.body.username
    )
    .then(
      (user) ->
        throw new Error('Username/email already exists.') if user
        encrypt(10)
    )
    .then(
      (salt) ->
        hash(req.body.password, salt)
    )
    .then(
      (hash) ->
        createUser(
          user_id: uuid.v1(),
          username: req.body.username,
          password: hash,
          joined: Date.now()
        )
    )
    .then(
      (user) ->
        res.json JSON.stringify(user)
    )
    .fail(
      (error) ->
        res.json JSON.stringify( 'error': 'message': error.message)
    )
    .done()

  validateParams = (params) ->
    for name, value of params
      unless value.length > 0
        return 'error': 'message': 'Don\'t just submit an empty form, brah.'
        break
      if name == 'username' && !validator.isEmail(value)
        return 'error': 'message': 'Invalid email, brah.'
        break
    null
