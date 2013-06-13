define [
  'child_process'
  'events'
  'module'
  'path'
], (child, events, module, path) ->

  class Heartbeat extends events.EventEmitter
    constructor: (heartrate) ->
      super()

      if heartrate?
        process.env.heartrate = heartrate

      # Do this in a separate process so that it more immune to server activity
      @childProcess = @_spawnChildProcess()

    kill: ->
      @childProcess.kill 'SIGKILL'

    _spawnChildProcess: ->
      filename = module.uri
      dirname = path.dirname(filename)

      childProcess = child.fork "#{dirname}/scripts/heartbeat.js", [],
        env: process.ENV
        silent: false

      childProcess.on 'message', (message) =>
        @emit 'beat' if message.type is 'heartbeat'

      # If the heartbeat stops, kill this process by throwing error
      childProcess.on 'exit', () ->
        throw "Heartbeat lost for process #{process.pid}"


      childProcess
