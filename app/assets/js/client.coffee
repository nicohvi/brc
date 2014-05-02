#= require 'lib/jquery-2.0.0.min.js'
#= require 'lib/underscore.min.js'
#= require 'lib/backbone.min.js'
#= require 'lib/icanhaz.min.js'
#= require 'lib/flip-jquery'
#= require_tree 'views'

# global variables
irc =
  connected: false,
  loggedIn: false,

$ ->
  irc.appView = new AppView()
