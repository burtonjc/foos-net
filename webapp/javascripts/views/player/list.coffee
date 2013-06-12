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

    collection: new (DomainCache.getCollection('players'))()

    initialize: (opts={}) ->
      @itemViewOptions.vent = opts.vent if opts.vent?
      @on 'itemview:remove', (itemview, model) => @trigger 'model:removed', model
      @on 'itemview:move', (itemview, model) => @trigger 'model:moved', model

    onClose: ->
      @collection.reset()
