module.exports = (schema) ->

  # create model schemas: the following models are necessary:
  # Users, Connections, Channels, Messages and PMs

  schema.define 'brc_user', {
    user_id:          { type: String },
    username:         { type: String },
    password:         { type: String },
    joined:           { type: Date, default: () -> new Date }
  }

  User = schema.models.brc_user
  User.validatesPresenceOf 'username', 'password'
  User.validatesLengthOf 'password', { min: 5}
  User.validatesUniquenessOf 'username'


  schema.define 'connection', {
    user_id:          { type: String }, # which user does this current connection belong to?
    hostname:         { type: String },
    port:             { type: Number },
    nick:             { type: String },
    away:             { type: String },
    serverPassword:   { type: String },
    realName:         { type: String },
    keepAlive:        { type: Boolean } # should brc keep this connection alive if user logs out?
  }

  Connection = schema.models.connection
  Connection.validatesPresenceOf 'hostname', 'port', 'nick'

  schema.define 'channel', {
    connection_id:   { type: Number },
    name:            { type: String }
  }

  Channel = schema.models.channel
  Channel.validatesPresenceOf 'connection_id', 'name'

  schema.define 'message', {
    connection_id:   { type: Number },
    from:            { type: String },
    channel:         { type: String },
    time:            { type: Date, default: () -> return new Date },
    message:         { type: String }
  }

  Message = schema.models.message
  Message.validatesPresenceOf 'connection_id', 'from', 'channel', 'message'


  schema.define 'private_message', {
    connection_id:   { type: Number },
    from:            { type: String },
    time:            { type: Date, default: () -> return new Date },
    message:         { type: String }
  }

  PM = schema.models.private_message
  PM.validatesPresenceOf 'connection_id', 'from', 'message'

  schema.autoupdate()

  schema
