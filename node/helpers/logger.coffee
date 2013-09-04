define [
  'winston'
], (winston) ->

  class Logger extends winston.Logger
    instance: null
    @getInstance: ->
      @instance ?= new @
        transports: [
          new winston.transports.Console(),
          new winston.transports.File
            filename:'foosnet.log'
            maxsize:1073741824
            maxFiles:5
        ]

  Logger.getInstance()
