define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->

  class Leagues extends Backbone.Collection
    url: '/leagues'
    model: DomainCache.getModel 'league'

    toJSON: ->
      (for model in @models
        model.id)

  DomainCache.addCollection 'leagues', Leagues
