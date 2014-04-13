mongoose = require 'mongoose'
irc = require '../../lib/irc/irc'
util = require 'util'
_ = require 'underscore'
Schema = mongoose.Schema

ircProxySchema = Schema
  _user:
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  nick: String
  servers: [serverSchema]

# TODO: more servers
serverSchema = Schema
  url: String
  channels: [channelSchema]

channelSchema = Schema
  name: String
  history: [messageSchema]
  status: String

messageSchema = Schema
  from: String,
  to: String,
  message: String

ircProxySchema.virtual('client').get ->
  @ircClient

ircProxySchema.virtual('client').set (client) ->
  @ircClient = client

ircProxySchema.methods.createClient = (options, done) ->

  console.log "createClient called with options: #{util.inspect options}"
  client = new irc.Client options.server, options.nick

  client.on 'error', (message) ->
    console.log "error received: #{util.inspect message}"

  client.on 'message', (from, to, message) =>
    channel = @servers[0].channels.filter( (channel) ->
        channel.name == to
    ).pop()

    channel.history.push { from: from, to: to, message: message }
    console.log "this is history: #{util.inspect channel.history}"

  client.on 'join', (channel, nick, message) =>
    proxyChannel = @servers[0].channels.filter( (_channel) ->
        _channel.name == channel
    ).pop()

    # create new channel if this is the first time we encounter it.
    unless proxyChannel?
      channel = { name: channel, history: [], status: 'active' }
      @servers[0].channels.push(channel)
    else
      proxyChannel.status = 'active'


  @client = client

  client.on 'registered', =>
    # add status channel to list of channels
    @servers[0].channels.push { name: '#status', history: [] }
    done()

# channels: list of strings representing channel names
ircProxySchema.methods.connect = (channels, done) ->
  for channel in channels
    @client.join channel, =>
      done() if _.keys(@client.chans).length == channels.length

ircProxySchema.methods.join = (channel, done) ->
  @client.join channel, =>
    done()

ircProxySchema.methods.part = (channel, done) ->
  @client.part channel, '' , =>
    @servers[0].channels.filter( (_channel) ->
      _channel.name == channel
    ).pop().status = 'inactive'
    done()

ircProxySchema.methods.say = (to, message, done) ->
  channel = @servers[0].channels.filter( (channel) ->
    channel.name == to
  ).pop()

  unless channel?
    channel = { name: to, history: [] }

  channel.history.push { from: @.nick, to: to, message: message }

  @client.say to, message
  done(@client) if done?

module.exports = db.model('IRCProxy', ircProxySchema)
