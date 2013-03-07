createContext({
    'controllers/MessagesController': 'mock/controllers/MessagesController'

}).require [
  'Routes'
], (Routes) ->

  describe "Routes", () ->
    it "should all have a path, a controller, and httpActions", () ->
      for route, idx in Routes
        expect(route.path).toBeDefined("path is undefined for route in idx: #{idx}")
        expect(route.path).not.toBeNull("path is null for route in idx: #{idx}")
        expect(route.controller).toBeDefined("controller is undefined for route in idx: #{idx}")
        expect(route.controller).not.toBeNull("controller is null for route in idx: #{idx}")
        expect(route.httpActions).toBeDefined("httpActions is undefined for route in idx: #{idx}")
        expect(route.httpActions).not.toBeNull("httpActions is null for route in idx: #{idx}")
        expect(route.httpActions.length).toBeGreaterThan(0, "httpActions has no actions for route in idx: #{idx}")
