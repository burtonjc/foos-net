define [
  'jquery'
  'underscore'
  'backbone.loader'
  'domain/cache'
  './item'

], ($, _, Backbone, DomainCache, MembershipItemView) ->
  Backbone.Marionette.CollectionView.extend
    itemView: MembershipItemView
    itemViewOptions:
      stationary: true
      slim: true
      hideElo: true
      permanent: false

    initialize: (opts={}) ->
      @itemViewOptions.hideElo = opts.hideElo ? @itemViewOptions.hideElo
      @itemViewOptions.permanent = opts.permanent ? @itemViewOptions.permanent
      @itemViewOptions.vent = opts.vent if opts.vent?
      @on 'itemview:remove', (itemview, model) => @trigger 'model:removed', model
      @on 'itemview:move', (itemview, model) => @trigger 'model:moved', model

    onClose: ->
      @collection.reset()
