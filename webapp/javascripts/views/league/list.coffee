define [
  'jquery'
  'underscore'
  'marionette'
  'collections/leagues'
  'views/league/item'

], ($, _, Marionette, LeagueCollection, LeagueItemView) ->
  Marionette.CollectionView.extend
    itemView: LeagueItemView
    className: 'league-list-view'

    collection: new LeagueCollection

    initialize: (opts={}) ->
      @itemViewOptions.vent = opts.vent if opts.vent?
      @on 'itemview:remove', (itemview, model) => @trigger 'model:removed', model
      @on 'itemview:move', (itemview, model) => @trigger 'model:moved', model

    onClose: ->
      @collection.reset()
