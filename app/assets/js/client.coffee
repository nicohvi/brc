#= require 'lib/underscore.min'
#= require 'lib/backbone.min'
#= require 'lib/react'
#= require 'lib/jquery-2.0.0.min'
#= require 'lib/flip-jquery'
#= require 'lib/post-jquery'
#= require 'lib/q'
#= require 'lib/validator'
#= require 'lib/errors'
#= require_tree components

# application entry-point
@.onload = ->
  React.renderComponent(
    Home({}),
    document.getElementById('app')
  )
