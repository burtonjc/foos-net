define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->

  class League extends Backbone.RelationalModel
    urlRoot: '/leagues'
    idAttribute: "_id"

    defaults:
      name: null
      description: null

  # Must have this for relations to work in coffeescript
  DomainCache.addModel 'league', League
  League.setup()
