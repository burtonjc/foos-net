describe "Routes", () ->
  before (done) =>
    requirejs [
      'routes'
    ], (routes) =>
      @routes = routes
      done()

  it "should all have a path, a controller, and actions", () =>
    _.each @routes, (config, path) =>
      controller = config.controller
      actions = config.actions

      should.exist controller, "No controller specified for path '#{path}'"
      should.exist actions, "No actions specified for path '#{path}'"
      actions.length.should.be.greaterThan 0, "There are no actions specified for controller at path '#{path}'"
      _.each actions, (action) ->
        should.exist controller[action], "Action '#{action}' does not exist on controller for path '#{path}'"
