define [
  'jquery'
  'underscore'
  'backbone.loader'
  'domain/cache'
  'views/league/item'
], ($, _, Backbone, DomainCache, LeagueItemView) ->

  Backbone.Marionette.CollectionView.extend
    itemView: LeagueItemView
    className: 'league-list-view'

    collection: new (DomainCache.getCollection('leagues'))()

    initialize: (opts={}) ->
      @itemViewOptions.vent = opts.vent if opts.vent?
      @on 'itemview:remove', (itemview, model) => @trigger 'model:removed', model
      @on 'itemview:move', (itemview, model) => @trigger 'model:moved', model

    onClose: ->
      @collection?.reset()
