define [
  'backbone.loader'
  'domain/cache'
], (Backbone, DomainCache) ->

  class Membership extends Backbone.RelationalModel
    urlRoot: '/memberships'
    idAttribute: '_id'

    defaults:
      rating: 1100

    relations: [{
      type: 'HasOne'
      key: 'player'
      relatedModel: 'player'
      includeInJSON: '_id'
      reverseRelation:
        key: 'memberships'
        collectionType: 'playermemberships'
        collectionOptions: (membership) ->
          membership: membership
    },{
      type: 'HasOne'
      key: 'league'
      relatedModel: 'league'
      includeInJSON: '_id'
      reverseRelation:
        key: 'memberships'
        collectionType: 'leaguememberships'
        collectionOptions: (membership) ->
          membership: membership
    }]
  

  # Must have this line for relations to work in coffeescript
  DomainCache.addModel 'membership', Membership
  Membership.setup()
