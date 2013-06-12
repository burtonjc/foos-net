define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->
  
  class LeaguePlayers extends Backbone.Collection
    model: DomainCache.getModel 'player'

    url: () ->
      "leagues/#{@league.id}/players"

    league: null

    initialize: (opts) ->
      @league = opts.league

  DomainCache.addCollection 'leagueplayers', LeaguePlayers
