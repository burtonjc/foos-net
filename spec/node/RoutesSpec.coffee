createContext({
    'controllers/MessagesController': 'mock/controllers/MessagesController'

}).require [
  'underscore'
  'Routes'
], (_, Routes) ->

  describe "Routes", () ->
    it "should all have a path, a controller, and httpActions", () ->
      _.each Routes, (controller, path) ->
        expect(controller).toBeDefined("controller is undefined for path #{path}")
        expect(controller).not.toBeNull("controller is null for path #{path}")
