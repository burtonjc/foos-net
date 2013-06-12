define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->
  
  class PlayerLeagues extends Backbone.Collection
    model: DomainCache.getModel 'league'

    url: () ->
      "players/#{@player.id}/leagues"

    player: null

    initialize: (opts) ->
      @player = opts.player

  DomainCache.addCollection 'playerleagues', PlayerLeagues