createContext(
  'restify':
    bodyParser: sinon.stub()
    serveStatic: sinon.stub()
  'models/player': {}
  'models/match': {}
).define [
  'underscore'
  'router'
  'routes'
  'restify'
], (_, router, routes, restify) ->
  get_server = () ->
    {
      get: sinon.spy()
      post: sinon.spy()
      put: sinon.spy()
      delete: sinon.spy()
      use: sinon.spy()
    }

  describe "Router", () ->

    describe "with invalid server", () ->
      it "should error on init if server is not valid", () ->
        expect(-> router.init({})).to.throw router.INVALID_SERVER_ERROR

    describe "with a valid server", () ->
      beforeEach () ->
        @server = get_server()
        router.init(@server)

      it "should use body parser", () ->
        # Keep these two expectations in this order
        restify.bodyParser.should.have.been.calledOnce
        @server.use.should.have.been.calledWith restify.bodyParser()

      it "should setup static serving for all requests", () ->
        # Keep these two expectations in this order
        restify.serveStatic.should.have.been.calledWith router.STATIC_CONFIG
        @server.get.should.have.been.calledWith router.ALL_ROUTES_REGEX, restify.serveStatic(router.STATIC_CONFIG)

      it "should wire up routes for all actions on handler", () ->
        _.each routes, (config, path) =>
          _.each router.HTTP_ACTION_METHOD_MAP, (method, action) =>
            if _.contains(config.actions, action)
              @server[method].should.have.been.calledWith path, config.controller[action]
