define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->
  
  class PlayerMatches extends Backbone.Collection
    model: DomainCache.getModel 'match'

    url: () ->
      "players/#{@player.id}/matches"

    player: null

    initialize: (opts) ->
      @player = opts.player

  DomainCache.addCollection 'playermatches', PlayerMatches
