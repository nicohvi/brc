module.exports = (app, passport) ->

  require('./main.routes')(app, passport)
  require('./irc-proxy.routes')(app, passport)
