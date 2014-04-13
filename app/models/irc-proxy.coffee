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

ircProxySchema.virtual('client').get ->
  @ircClient

ircProxySchema.virtual('client').set (client) ->
  @ircClient = client

ircProxySchema.methods.createClient = (options, done) ->
  console.log "connect called with options: #{util.inspect options}"
  client = new irc.Client options.server, options.nick
  client.on 'error', (message) ->
    console.log "error received: #{util.inspect message}"
  @client = client
  client.on 'registered', ->
    done(null, client)

ircProxySchema.methods.connect = (channels, done) ->
  for channel in channels
    @client.join channel, =>
      console.log "this is client: #{util.inspect @client}"
      done(@client) if channel == channels[..].pop()
      @client.on "message##{channel}", (from, text, message) ->
        console.log "Message in channel #{channel}: #{message}"

module.exports = db.model('IRCProxy', ircProxySchema)
