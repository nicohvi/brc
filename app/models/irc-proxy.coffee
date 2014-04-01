mongoose = require 'mongoose'
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

module.exports = db.model('IRCProxy', ircProxySchema)
