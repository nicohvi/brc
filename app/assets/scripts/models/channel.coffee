root = exports ? this

class Channel

  constructor: (@name, @events, opts) ->
    @mode = opts.mode
    @topic = opts.topic
    @history = []
    @initListeners()
    @updateView()

  initListeners: =>
    @events.on 'add_message:channel', (message) =>
      console.log "message: #{JSON.stringify message}"
      return false unless message.to == @name
      @addMessage(message.from, message.message)

  addMessage: (sender, message) =>
    @history.push {sender: sender, message: message}
    @updateView()

  updateView: =>
    $('#irc').html templatizer.channel(@toString())

  toString: =>
    { channel: { name: @name, history: @history }}

root.Channel = Channel
