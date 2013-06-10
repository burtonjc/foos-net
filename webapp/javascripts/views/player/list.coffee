define [
  'jquery'
  'underscore'
  'marionette'
  'collections/players'
  'views/game/pairchooser/playercard'

], ($, _, Marionette, PlayerCollection, PlayerCard) ->
  Marionette.CollectionView.extend
    itemView: PlayerCard
    itemViewOptions:
      stationary: true
      slim: true
      hideElo: true

    collection: new PlayerCollection

    initialize: (opts={}) ->
      @itemViewOptions.vent = opts.vent if opts.vent?
      @on 'itemview:remove', (itemview, model) => @trigger 'model:removed', model
      @on 'itemview:move', (itemview, model) => @trigger 'model:moved', model

    onClose: ->
      @collection.reset()
