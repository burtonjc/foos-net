createContext({
    'controllers/players_controller': 'mock/controllers/players_controller',
    'controllers/matches_controller': 'mock/controllers/matches_controller'

}).require [
  'underscore'
  'routes'
], (_, Routes) ->

  describe "Routes", () ->
    it "should all have a path, a controller, and httpActions", () ->
      _.each Routes, (controller, path) ->
        expect(controller).toBeDefined("controller is undefined for path #{path}")
        expect(controller).not.toBeNull("controller is null for path #{path}")
