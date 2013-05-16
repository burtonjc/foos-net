define [
  'underscore'
  'restify'
  'routes'

], (_, restify, Routes) ->

  INVALID_SERVER_ERROR: "Router requires a server instance."
  HTTP_ACTION_METHOD_MAP:
    'get'   : 'get'
    'query' : 'get'
    'create': 'post'
    'update': 'put'
    'delete': 'delete'

  ALL_ROUTES_REGEX: /\/*/
  STATIC_CONFIG:
    'directory': './target/webapp/'
    'default': 'templates/index.html'

  init: (server) ->
    if  !(server && _.isFunction(server.use) && _.isFunction(server.get))
      throw new Error(@INVALID_SERVER_ERROR)

    server.use restify.bodyParser()
    @_registerRoutes(server)

    # It is important to register all routes before this line
    server.get @ALL_ROUTES_REGEX, restify.serveStatic(@STATIC_CONFIG)

  _registerRoutes: (server) ->
    _.each Routes, (config, path) =>
      _.each config.actions, (action) =>
        server[@HTTP_ACTION_METHOD_MAP[action]](path, config.controller[action])
