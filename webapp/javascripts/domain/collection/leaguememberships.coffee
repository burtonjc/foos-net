define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->
  
  class LeagueMemberships extends Backbone.Collection
    model: DomainCache.getModel 'membership'

    url: () ->
      "leagues/#{@league.id}/memberships"

    league: null

    initialize: (models, opts) ->
      @league = opts.league if opts?.league?

    comparator: (membership) ->
      -membership.get("rating")

    getPlayers: ->
      PlayerCollection = DomainCache.getCollection 'players'
      models = (for membership in @models
                  membership.get('player'))
      new PlayerCollection models

  DomainCache.addCollection 'leaguememberships', LeagueMemberships
