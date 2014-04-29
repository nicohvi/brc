module.exports = (schema) ->

  # create model schemas: the following models are necessary:
  # Users, Connections, Channels, Messages and PMs



  schema.define 'User', {
    user_id:          { type: String },
    username:         { type: String },
    password:         { type: String },
    joined:           { type: Date, default: () -> new Date }
  }

  schema.define 'Connection', {
    user_id:          { type: String }, # which user does this current connection belong to?
    hostname:         { type: String },
    port:             { type: Number },
    nick:             { type: String },
    away:             { type: String },
    serverPassword:   { type: String },
    realName:         { type: String },
    keepAlive:        { type: Boolean } # should brc keep this connection alive if user logs out?
  }

  schema.define 'Channel', {
    connection_id:   { type: Number },
    name:            { type: String }
  }

  schema.define 'Message', {
    connection_id:   { type: Number },
    from:            { type: String },
    channel:         { type: String },
    time:            { type: Date, default: () -> return new Date },
    message:         { type: String }
  }


  schema.define 'PM', {
    connection_id:   { type: Number },
    from:            { type: String },
    time:            { type: Date, default: () -> return new Date },
    message:         { type: String }
  }

  schema.autoupdate()
