define [
  './ekg'
  './heartbeat'
], (Ekg, Heartbeat) ->

  class LubDub
    constructor: (@threashold, heartrate) ->
      heartbeat = new Heartbeat(heartrate)
      @ekg = new Ekg()
      @ekg.monitor heartbeat

      # If this process goes down, kill the heartbeat
      process.on 'exit', -> heartbeat.kill()

      # Check heartbeat every second
      setInterval =>
        @check
      , 1000
      
    check: ->
      if (Date.now() - @ekg.getLatestBeat()) > @threashold
        # Maybe do something useful here like bounce the process
        false
      else
        true

