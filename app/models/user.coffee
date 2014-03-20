bcrypt = require 'bcrypt-nodejs'
util = require 'util'
mongoose = require 'mongoose'

userSchema = mongoose.Schema {
  email: {
    type: String,
    unique: true
  },
  password: String
}

userSchema.pre 'save', (next) ->
  @password = bcrypt.hashSync(@password, bcrypt.genSaltSync(8), null)
  next()

# userSchema.statics.generateHash = (password) ->
#     bcrypt.hashSync(password, bcrypt.genSaltSync(8), null)

userSchema.methods.validPassword = (password) ->
    bcrypt.compareSync(password, @password)

module.exports = mongoose.model('User', userSchema);
