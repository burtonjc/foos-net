define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->

  class Player extends Backbone.RelationalModel
    urlRoot: '/players'
    idAttribute: "_id"

    defaults:
      name: null
      email: null

  # Must have this line for relations to work in coffeescript
  DomainCache.addModel 'player', Player
  Player.setup()
