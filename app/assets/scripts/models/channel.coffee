root = exports ? this

class Channel

  constructor: (@name, @events, opts) ->
    @mode = opts.mode
    @topic = opts.topic
    @history = []
    @updateView()

  addMessage: (message) =>
    @history.push message
    @updateView()

  updateView: =>
    console.log "name: #{@name}"
    console.log "tostring: #{JSON.stringify @toString()}"
    console.log "self: #{JSON.stringify @}"

    $('#irc').html templatizer.channel(@toString())

  toString: =>
    { channel: { name: @name }}

root.Channel = Channel
