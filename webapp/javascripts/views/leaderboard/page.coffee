define [
  'jquery'
  'underscore'
  'backbone.loader'
  'tpl!templates/leaderboard/page.html'
  'views/game/pairchooser/playercard'
  'domain/cache'

], ($, _, Backbone, LeaderBoardPageTpl, PlayerCard, DomainCache) ->
  
  Backbone.Marionette.CompositeView.extend
    className: 'hero-unit leaderboard'
    template: LeaderBoardPageTpl
    itemView: PlayerCard
    itemViewContainer: 'div.players'
    itemViewOptions:
      permanent: true
      stationary: true
      slim: true
      imgSize: 60

    collection: new (DomainCache.getCollection('players'))()

    initialize: (opts) ->
      @collection.fetch()

    onClose: ->
      @collection.reset()
