bcrypt = require 'bcrypt-nodejs'
util = require 'util'
mongoose = require 'mongoose'

userSchema = mongoose.Schema {
  email: String,
  password: String
}

userSchema.statics.generateHash = (password) ->
    bcrypt.hashSync(password, bcrypt.genSaltSync(8), null)

userSchema.methods.validPassword = (password) ->
    bcrypt.compareSync(password, @password)

module.exports = mongoose.model('User', userSchema);
