mongoose = require 'mongoose'
Schema = mongoose.Schema

ircProxySchema = Schema
  _user:
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  history: [serverSchema]

serverSchema = Schema
  channels: [channelSchema]

channelSchema = Schema
   messages: [messageSchema]

messageSchema = Schema
  from: String,
  to: String,
  message: String

module.exports = db.model('IRCProxy', ircProxySchema)
