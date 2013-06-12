define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->
  
  class PlayerMemberships extends Backbone.Collection
    model: DomainCache.getModel 'membership'

    url: (modles) ->
      "players/#{@player.id}/memberships"

    player: null

    initialize: (models, opts) ->
      @player = opts.player

  DomainCache.addCollection 'playermemberships', PlayerMemberships
