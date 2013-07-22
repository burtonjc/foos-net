define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->
  
  class Memberships extends Backbone.Collection
    url: '/memberships'
    model: DomainCache.getModel 'membership'

    comparator: (membership) ->
      -membership.get("rating")

  DomainCache.addCollection 'memberships', Memberships
