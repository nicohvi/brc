express = require 'express'
fs = require 'fs'

module.exports = (parentApp) ->
  fs.readdirSync("#{__dirname}/../app/controllers").forEach (name) ->
    console.log('\n %s', name)
    # TODO: create MVC-like controllers
    # controller = require "./../app/controllers/#{name}"
    # app = express()
    # method, path

    # middleware
    # if controller.before
      # path = "/#{name}/:"
