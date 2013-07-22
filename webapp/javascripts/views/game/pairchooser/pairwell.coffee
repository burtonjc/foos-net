define [
  'jquery'
  'underscore'
  'backbone.loader'
  'views/membership/item'

], ($, _, Backbone, MembershipItemView) ->

  Backbone.Marionette.CollectionView.extend
    className: 'well pair-drop-ct'
    itemView: MembershipItemView

    initialize: (opts) ->
      @itemViewOptions =
        vent: opts.vent
        league: opts.league
