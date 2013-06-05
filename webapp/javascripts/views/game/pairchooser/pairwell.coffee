define [
  'jquery'
  'underscore'
  'marionette'
  'views/game/pairchooser/playercard'

], ($, _, Marionette, PlayerCard) ->

  Marionette.CollectionView.extend
    className: 'well pair-drop-ct'
    itemView: PlayerCard

    initialize: (opts) ->
      @itemViewOptions =
        vent: opts.vent
