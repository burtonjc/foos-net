createContext({
  'restify': {
    bodyParser: () ->
    serveStatic: () ->
  }
  'models/Message': {}
}).require [
  'Router'
], (Router) ->

  describe "Router", () ->
    it "should error on init if server is not valid", () ->
      expect(() ->
        Router.init({})
      ).toThrow(new Error(Router.INVALID_SERVER_ERROR))

    it "should not error if server looks valid", () ->
      expect(() ->
        Router.init({use: () ->})
      ).not.toThrow(new Error(Router.INVALID_SERVER_ERROR))
