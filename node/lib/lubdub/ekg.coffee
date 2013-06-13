define ->

  class Ekg
    constructor: ->
      @latestBeat = null

    monitor: (heartbeat) ->
      heartbeat.on 'beat', =>
        @latestBeat = Date.now()

    getLatestBeat: ->
      @latestBeat
