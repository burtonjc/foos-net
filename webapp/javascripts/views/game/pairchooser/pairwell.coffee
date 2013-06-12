define [
  'jquery'
  'underscore'
  'backbone.loader'
  'views/game/pairchooser/playercard'

], ($, _, Backbone, PlayerCard) ->

  Backbone.Marionette.CollectionView.extend
    className: 'well pair-drop-ct'
    itemView: PlayerCard

    initialize: (opts) ->
      @itemViewOptions =
        vent: opts.vent
        league: opts.league
