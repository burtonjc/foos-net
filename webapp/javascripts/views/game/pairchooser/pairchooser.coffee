define [
  'jquery'
  'underscore'
  'backbone.loader'
  'views/game/pairchooser/pairwell'
  'domain/cache'
  'tpl!templates/game/pairchooser/pairchooser.html'

], ($, _, Backbone, PairWell, DomainCache, PairChooserTpl) ->

  Backbone.Marionette.Layout.extend
    template: PairChooserTpl
    className: 'pair-chooser'

    regions:
      pairOneCt: '.pair-ct.one'
      pairTwoCt: '.pair-ct.two'

    ui:
      pairOneElo: '.pair-elo.one'
      pairTwoElo: '.pair-elo.two'

    collection: new (DomainCache.getCollection('memberships'))()
    vent: null

    collectionEvents:
      'add': '_divvyUpPairs'
      'remove': '_divvyUpPairs'

    initialize: (opts) ->
      @vent = opts.vent ? _.extend {}, Backbone.Events
      @vent.on 'player:remove', (model) => @trigger 'model:removed', model
      @vent.on 'player:move', (model) => @trigger 'model:moved', model
      @league = opts.league ? null

    onClose: ->
      @collection.reset()
      for pair in @getPairs()
        pair.reset()

    onRender: () ->
      @pairOneCt.show @_createPairWell()
      @pairTwoCt.show @_createPairWell()

      @_divvyUpPairs()
      @_updatePairEloRaitings()

      @vent.on 'player:move', (player) ->
        @_tradePlayer player
      , @

    _createPairWell: () ->
      pairWell = new PairWell
        collection: new (DomainCache.getCollection('memberships'))()
        league: @league
        vent: @vent

      pairWell

    _tradePlayer: (membership) ->
      pairs = @getPairs()
      if pairs[0].contains membership
        pairs[0].remove membership
        pairs[1].add membership
      else
        pairs[1].remove membership
        pairs[0].add membership

      @_updatePairEloRaitings()
      @_checkReady()

    getPairs: () ->
      _.compact [
        @pairOneCt?.currentView.collection
        @pairTwoCt?.currentView.collection
      ]

    _divvyUpPairs: () ->
      pairs = @getPairs()
      for pair in pairs
        pair.reset()

      @collection.each (model, idx) =>  
        if idx is 0 or idx is (@collection.length - 1)
          pairs[0].add model
        else
          pairs[1].add model

      @_updatePairEloRaitings()
      @_checkReady()

    _updatePairEloRaitings: () ->
      debugger
      pairs = @getPairs()
      pairOneRaitings = pairs[0].pluck('rating')
      pairTwoRaitings = pairs[1].pluck('rating')

      @ui.pairOneElo.html @_average(pairOneRaitings)
      @ui.pairTwoElo.html @_average(pairTwoRaitings)

    _checkReady: () ->
      pairs = @getPairs()

      if pairs[0].length is 2 and pairs[1].length is 2
        @vent.trigger 'ready'
      else
        @vent.trigger 'notready'

    _average:  (arr) ->
      avg = _.reduce(arr, (memo, num) ->
        memo + num
      , 0) / arr.length
      Math.floor avg
