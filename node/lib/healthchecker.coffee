define [
  'underscore'
], (_) ->

  class HealthChecker
    constructor: (@server) ->
      @checks = []
      server.get '/metrics/healthcheck', _.bind(@handler, @)

    register: (checks) ->
      if _.isObject(checks)
        _.extend @checks, checks

    handler: (request, response, next) ->
      results = {}
      for name, check of  @checks
        done = _.bind(@_recordResult, @, response, name, results, next)
        (results[name]={}).starttime = Date.now()
        check(done)

    _recordResult: (response, checkName, results, next, successful, message) ->
      results[checkName].durration = "#{Date.now() - results[checkName].starttime}ms"
      delete results[checkName].starttime

      unless successful
        response.statusCode = 500
      if message?
        results[checkName].message = message

      results[checkName].successful = successful
      if _.every(_.values(results), (result) -> !result.hasOwnProperty('starttime'))
        response.send results
        next()
