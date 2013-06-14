define [
  'jquery'
  'underscore'
  'backbone.loader'
  'domain/cache'
  'views/game/pairchooser/playercard'

], ($, _, Backbone, DomainCache, PlayerCard) ->
  Backbone.Marionette.CollectionView.extend
    itemView: PlayerCard
    itemViewOptions:
      stationary: true
      slim: true
      hideElo: true
      permanent: false

    collection: new (DomainCache.getCollection('players'))()

    initialize: (opts={}) ->
      @itemViewOptions.hideElo = opts.hideElo ? @itemViewOptions.hideElo
      @itemViewOptions.permanent = opts.permanent ? @itemViewOptions.permanent
      @itemViewOptions.vent = opts.vent if opts.vent?
      @on 'itemview:remove', (itemview, model) => @trigger 'model:removed', model
      @on 'itemview:move', (itemview, model) => @trigger 'model:moved', model

    onClose: ->
      @collection.reset()

    setLeague: (league) ->
      @itemViewOptions.league = league
