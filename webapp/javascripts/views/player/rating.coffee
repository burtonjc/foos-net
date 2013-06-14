define [
  'jquery'
  'underscore'
  'backbone.loader'
  'domain/cache'
], ($, _, Backbone, DomainCache) ->

  Backbone.Marionette.ItemView.extend
    template: _.template ''
    className: 'player-rating'
    tagName: 'span'

    ui:
      rating: '.rating'

    player: null
    playerMemberships: null

    initialize: (opts={}) ->
      @player = opts.player
      @league = opts.league
      PlayerMemberships = DomainCache.getCollection 'playermemberships'
      @playerMemberships = @player.get('memberships').fetch()

    onRender: ->
      @playerMemberships.then (memberships) =>
        rating = _.findWhere(memberships, league: @league.id)?.rating
        @$el.html rating
