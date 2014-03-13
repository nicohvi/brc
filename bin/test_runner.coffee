spawn = require('child_process').spawn
server = require '../utils/server.coffee'

server.start 8100, ->
  jasmineNode = spawn('jasmine-node',
                      ['--coffee', '--color', '--autotest', '../spec/'])

  logToConsole = (data) ->
    console.log(String(data))

  jasmineNode.stdout.on('data', logToConsole);
  jasmineNode.stderr.on('data', logToConsole);

  jasmineNode.on('exit', (exitCode) ->
    server.close())
