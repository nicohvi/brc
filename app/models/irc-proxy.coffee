# mongoose = require 'mongoose'
# irc = require '../../config/irc-bridge'
# util = require 'util'
# events = require 'events'
# _ = require 'underscore'
# Schema = mongoose.Schema
#
# ircProxySchema = Schema
#   _user:
#     type: Schema.Types.ObjectId,
#     ref: 'User',
#     required: true,
#     unique: true
#   nick: String
#   connected: Boolean
#   servers: [serverSchema]
#
# serverSchema = Schema
#   url: String
#   channels: [channelSchema]
#
# channelSchema = Schema
#   name: String
#   history: [messageSchema]
#
# messageSchema = Schema
#   from: String,
#   to: String,
#   message: String
#
# # virtuals might be redundant
# # ircProxySchema.virtual('client').get ->
# #   @ircClient
# #
# # ircProxySchema.virtual('client').set (client) ->
# #   @ircClient = client
#
# ircProxySchema.virtual('events').get ->
#   @eventEmitter
#
# ircProxySchema.virtual('events').set (eventEmitter) ->
#   @eventEmitter = eventEmitter
#
# ircProxySchema.methods.createClient = (options, done) ->
#   unless options?
#     client = new irc.Client @servers[0].url, @nick
#   else
#     client = new irc.Client options.server, options.nick
#
#   console.log "Created IRC client: #{util.inspect client}"
#   # instantiate virtual attributes
#   @client = client
#   @events = new events.EventEmitter()
#
#   @initClientBindings()
#
#   client.on 'registered', =>
#     # add status channel to list of channels
#     @servers[0].channels.push { name: '#status', history: [] }
#     @events.emit 'registered'
#     done() if done?
#
# ircProxySchema.methods.initClientBindings = ->
#   @client.on 'error', (message) =>
#     console.log "error received: #{util.inspect message}"
#
#   @client.on 'message', (from, to, message) =>
#     console.log "client got message"
#     # addToHistory(from, to, message)
#     @events.emit 'message', {from: from, to: to, message: message}
#
#   # motd emitted right after joining the server
#   @client.on 'motd', (motd) =>
#     console.log "MOTD: #{util.inspect(motd)}"
#     # @events.emit 'message', {to: '#status', message: motd}
#
#   @client.on 'raw', (message) =>
#     return false if message.command == "PING"
#     # console.log "RAW MESSAGE: #{util.inspect((message.args[1]))}"
#     @events.emit 'message', { from: message.prefix, to: '#status', message: message.args[1] }
#
# # channels: list of strings representing channel names
# ircProxySchema.methods.connect = (channels, done) ->
#   for channel in channels
#     @client.join channel, =>
#       done() if _.keys(@client.chans).length == channels.length
#
# ircProxySchema.methods.join = (channel, done) ->
#   @client.join channel, =>
#     unless channel in @servers[0].channels
#       @servers[0].channels.push { name: channel, history: [] }
#     @servers[0].channels.filter( (_channel) ->
#       _channel.name == channel
#     ).pop().status = 'active'
#     done()
#
# ircProxySchema.methods.part = (channel, done) ->
#   @client.part channel, '' , =>
#     @servers[0].channels.filter( (_channel) ->
#       _channel.name == channel
#     ).pop().status = 'inactive'
#     done()
#
# ircProxySchema.methods.say = (to, message, done) ->
#   channel = @servers[0].channels.filter( (channel) ->
#     channel.name == to
#   ).pop()
#
#   unless channel?
#     channel = { name: to, history: [] }
#
#   channel.history.push { from: @.nick, to: to, message: message }
#
#   @client.say to, message
#   done(@client) if done?
# #
# # ircProxySchema.methods.emit = (event, data) ->
# #
# #   @db.model('IRCProxy').emit event, data
#
# module.exports = mongoose.model('IRCProxy', ircProxySchema)
