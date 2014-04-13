mongoose = require 'mongoose'
irc = require '../../lib/irc/irc'
util = require 'util'
Schema = mongoose.Schema

ircProxySchema = Schema
  _user:
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  nick: String
  servers: [serverSchema]

serverSchema = Schema
  url: String
  channels: [channelSchema]

channelSchema = Schema
  name: String
  history: [messageSchema]

messageSchema = Schema
  from: String,
  to: String,
  message: String

ircProxySchema.virtual('client').get( ->
  @ircClient
)

ircProxySchema.virtual('client').set( (client) ->
  @ircClient = client
)

ircProxySchema.methods.createClient = (options, done) ->
  console.log "connect called with options: #{util.inspect options}"
  client = new irc.Client options.server, options.nick
  @client = client
  done(null, client)

ircProxySchema.methods.connect = (channels) ->
  for channel in channels
    console.log "what is client? #{util.inspect(@client)}"
    @client.join channel, ->
      @client.on "message##{channel}", (from, text, message) ->
        console.log "Message in channel #{channel}: #{message}"

module.exports = db.model('IRCProxy', ircProxySchema)
