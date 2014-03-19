# express = require 'express'
# fs = require 'fs'
#
# module.exports = (app, options) ->
#   verbose = options.verbose
#   fs.readdirSync("#{__dirname}/../app/controllers").forEach (name) ->
#
#     verbose && console.log "File: #{name}"
#
#     controller = require "./../app/controllers/#{name}"
#     middleware = express()
#     name = controller.name || name
#     prefix = controller.prefix || ''
#     method = ''
#     path = ''
#
#     # set view folder for the controller middleware
#     middleware.set('views', "#{__dirname}/../app/views")
#
#     # before_filter
#     if controller.before
#       path = '*'
#       middleware.all(path, controller.before)
#       verbose && console.log "before_all: #{controller.before}"
#
#     # generate routes based on exported controller methods
#     for action of controller
#       # "reserved" exports
#       continue if (~['name', 'prefix', 'engine', 'before'].indexOf(action))
#
#       switch action
#         when 'new'
#           method = 'get'
#           path = "/#{name}/new"
#
#         when 'create'
#           method = 'post'
#           path = "/#{name}"
#
#         when 'show'
#           method = 'get'
#           path = "/#{name}/:#{name}_id"
#
#         when 'edit'
#           method = 'get'
#           path = "/#{name}/:#{name}_id/edit"
#
#         when 'update'
#           method = 'put'
#           path = "/#{name}/:#{name}_id"
#
#         when 'index'
#           method = 'get'
#           path = '/'
#
#         when 'login'
#           method = 'get'
#           path = '/login'
#
#         when 'login!'
#           method = 'get'
#           path = '/login!'
#
#         else
#           throw new Error "Unrecognized route: #{name}##{action}"
#
#       path = prefix + path
#
#       verbose && console.log "\n method: #{method}, action: #{action}"
#
#       middleware[method](path, controller[action])
#
#     # use the newly configured middleware
#     app.use(middleware)
