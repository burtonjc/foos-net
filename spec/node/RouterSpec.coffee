createContext({
  'restify': {
    bodyParser: jasmine.createSpy('restify.bodyParser')
    serveStatic: jasmine.createSpy('restify.serveStatic')
  },
  'models/player': {}
}).require [
  'underscore',
  'router',
  'routes',
  'restify'
], (underscore, Router, Routes, restify) ->

  server = null
  get_server = () ->
    {
      get: jasmine.createSpy('server.get')
      post: jasmine.createSpy('server.post')
      put: jasmine.createSpy('server.put')
      delete: jasmine.createSpy('server.delete')
      use: jasmine.createSpy('server.use')
    }

  describe "Router", () ->
    describe "with invalid server", () ->
      it "should error on init if server is not valid", () ->
        expect(() ->
          Router.init({})
        ).toThrow(new Error(Router.INVALID_SERVER_ERROR))

    describe "with a valid server", () ->
      beforeEach () ->
        server = get_server()
        Router.init(server)

      it "should use body parser", () ->
        # Keep these two expectations in this order
        expect(restify.bodyParser).toHaveBeenCalled()
        expect(server.use).toHaveBeenCalledWith(restify.bodyParser())

      it "should setup static serving for all requests", () ->
        # Keep these two expectations in this order
        expect(restify.serveStatic).toHaveBeenCalledWith(Router.STATIC_CONFIG)
        expect(server.get).toHaveBeenCalledWith(Router.ALL_ROUTES_REGEX, restify.serveStatic(Router.STATIC_CONFIG))

      it "should wire up routes for all actions on handler", () ->
        _.each Routes, (controller, path) ->
          _.each Router.HTTP_ACTIONS, (action) ->
            if _.isFunction controller[action]
              expect(server[action]).toHaveBeenCalledWith(path, controller[action])
            else
              expect(server[action]).not.toHaveBeenCalledWith(path)
              expect(server[action]).not.toHaveBeenCalledWith(path, controller[action])
