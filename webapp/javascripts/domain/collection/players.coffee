define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->
  
  class Players extends Backbone.Collection
    url: '/players'
    model: DomainCache.getModel 'player'

    comparator: (player) ->
      player.get("name")

    toJSON: ->
      (for model in @models
        model.id)

  DomainCache.addCollection 'players', Players
