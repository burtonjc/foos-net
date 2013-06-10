define [
  'jquery'
  'underscore'
  'marionette'
  'views/game/pairchooser/pairwell'
  'collections/players'
  'tpl!templates/game/pairchooser/pairchooser.html'

], ($, _, Marionette, PairWell, PlayersCollection, PairChooserTpl) ->

  Marionette.Layout.extend
    template: PairChooserTpl
    className: 'pair-chooser'

    regions:
      pairOneCt: '.pair-ct.one'
      pairTwoCt: '.pair-ct.two'

    ui:
      pairOneElo: '.pair-elo.one'
      pairTwoElo: '.pair-elo.two'

    collection: new PlayersCollection
    vent: null

    collectionEvents:
      'add': '_divvyUpPairs'
      'remove': '_divvyUpPairs'

    initialize: (opts) ->
      @vent = opts.vent ? _.extend {}, Backbone.Events
      @vent.on 'player:remove', (model) => @trigger 'model:removed', model
      @vent.on 'player:move', (model) => @trigger 'model:moved', model


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
        collection: new PlayersCollection()
        vent: @vent

      pairWell

    _tradePlayer: (player) ->
      pairs = @getPairs()
      if pairs[0].contains player
        pairs[0].remove player
        pairs[1].add player
      else
        pairs[1].remove player
        pairs[0].add player

      @_updatePairEloRaitings()
      @_checkReady()

    getPairs: () ->
      [
        @pairOneCt.currentView.collection
        @pairTwoCt.currentView.collection
      ]

    _divvyUpPairs: () ->
      pairs = @getPairs()
      for pair in pairs
        pair.reset()

      for player, idx in @collection.models
        if idx is 0 or idx is (@collection.length - 1)
          pairs[0].add player
        else
          pairs[1].add player

      @_updatePairEloRaitings()
      @_checkReady()

    _updatePairEloRaitings: () ->
      pairOnePlayers = @pairOneCt.currentView.collection
      pairTwoPlayers = @pairTwoCt.currentView.collection
      pairOneElos = _.chain(pairOnePlayers.models).pluck('attributes').pluck('elo').value()
      pairTwoElos = _.chain(pairTwoPlayers.models).pluck('attributes').pluck('elo').value()

      @ui.pairOneElo.html @_average(pairOneElos)
      @ui.pairTwoElo.html @_average(pairTwoElos)

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
