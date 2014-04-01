bcrypt = require 'bcrypt-nodejs'
mongoose = require 'mongoose'

userSchema = mongoose.Schema
  email:
    type: String,
    unique: true,
    required: true
  password:
    type: String,
    required: true

# filter called before save. Encrypts the password before it gets
# stored to the database.
userSchema.pre 'save', (next) ->
  @password = bcrypt.hashSync(@password, bcrypt.genSaltSync(8), null)
  next()

userSchema.methods.validPassword = (password) ->
    bcrypt.compareSync(password, @password)

module.exports = db.model('User', userSchema)
