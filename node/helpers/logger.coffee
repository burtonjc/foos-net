define [
  'winston'

], (winston) ->
  init: () ->
    winston.add winston.transports.File, filename:'foos-net.log', maxsize:1073741824, maxFiles:5
    winston.remove winston.transports.Console
