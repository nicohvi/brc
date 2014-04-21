root = exports ? this

class ChannelController

  constructor: (@events) ->
    @initListeners()
    @channels = []

  initListeners: =>

    @events.on 'add_channel', (channel) =>
      @channels.push new Channel(channel, @events, {})

    @events.on 'message', (message) =>

      channel = @channels.filter( (_channel) ->
        _channel.name == message.to
      ).pop()

      console.log "channel: #{JSON.stringify(channel)}"

      @channels.push new Channel(message.to, @events, {}) unless channel?

      @events.emit 'add_message', channel


root.ChannelController = ChannelController
