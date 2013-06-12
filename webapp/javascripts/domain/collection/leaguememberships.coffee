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
      @league = opts.league

    comparator: (membership) ->
      membership.get("rating")

  DomainCache.addCollection 'leaguememberships', LeagueMemberships
