app = require('./server').app

# routes
app.get "/", (req, res) ->
  res.send "Hello world"

app.get "/test", (req, res) ->
  res.send "Test route"
