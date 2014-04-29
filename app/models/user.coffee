# bcrypt = require 'bcrypt-nodejs'
# mongoose = require 'mongoose'
# IRCProxy = require './irc-proxy'
# util = require 'util'
#
# userSchema = mongoose.Schema
#   email:
#     type: String,
#     unique: true,
#     required: true
#   password:
#     type: String,
#     required: true
#
# # filter called before save. Encrypts the password before it gets
# # stored to the database.
# userSchema.pre 'save', (next) ->
#   @password = bcrypt.hashSync(@password, bcrypt.genSaltSync(8), null)
#   next()
#
# userSchema.methods.validPassword = (password) ->
#   bcrypt.compareSync(password, @password)
#
# userSchema.methods.getIrcProxy = (done) ->
#   IRCProxy.findOne( { _user: @._id }, (error, proxy) ->
#     if done?
#       return done(error, null) if error
#       done(null,proxy)
#   ) # findOne
#
# userSchema.methods.createProxy = (done) ->
#   ircProxy = new IRCProxy { _user: @._id }
#   ircProxy.save (error) ->
#     done(error, null) if error
#     done(null, ircProxy)
#
# module.exports = User = mongoose.model('User', userSchema)
