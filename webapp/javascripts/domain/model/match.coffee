define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->

  class Match extends Backbone.RelationalModel
    urlRoot: '/matches'
    idAttribute: "_id"

    defaults:
      date: Date.now
      league: null
      winners: []
      losers: []

  # Must have this line for relations to work in coffeescript
  DomainCache.addModel 'match', Match
  Match.setup()
