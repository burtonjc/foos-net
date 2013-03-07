createContext({
    'controllers/MessagesController': 'mock/controllers/MessagesController'

}).require [
  'Routes'
], (Routes) ->

  describe "Routes", () ->
    it "should all have a path, a controller, and httpActions", () ->
      for route in Routes
        expect(route.path).toBeDefined()
        expect(route.path).not.toBeNull()
        expect(route.controller).toBeDefined()
        expect(route.controller).not.toBeNull()
        expect(route.httpActions).toBeDefined()
        expect(route.httpActions).not.toBeNull()
