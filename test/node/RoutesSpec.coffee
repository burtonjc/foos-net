describe "Routes", () ->
  before (done) =>
    createContext(
      'controllers/matches_controller': 'mock/controllers/matches_controller'
      'controllers/players_controller': 'mock/controllers/players_controller'
    ).require [
      'routes'
    ], (routes) =>
      @routes = routes
      done()

  it "should all have a path, a controller, and httpActions", () =>
    _.each @routes, (controller, path) =>
      controller.should.exist
