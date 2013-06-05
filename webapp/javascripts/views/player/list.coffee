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

    vent: null

    initialize: (opts) ->
      @itemViewOptions.vent = opts.vent
