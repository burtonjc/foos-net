define [
  'jquery'
  'jqueryui'
  'underscore'
  'marionette'
  'views/game/pairchooser/pairwell'
  'collections/players'
  'tpl!templates/game/pairchooser/pairchooser.html'

], ($, jqueryui, _, Marionette, PairWell, PlayersCollection, PairChooserTpl) ->

  Marionette.Layout.extend
    template: PairChooserTpl
    className: 'pair-chooser'

    players: null

    regions:
      pairOneCt: '.pair-ct.one'
      pairTwoCt: '.pair-ct.two'

    ui:
      pairOneElo: '.pair-elo.one'
      pairTwoElo: '.pair-elo.two'

    initialize: (opts) ->
      @players = opts.players

    onRender: () ->
      @pairOneCt.show @_getNextPairView(@players)
      @pairTwoCt.show @_getNextPairView(@players)

      @_updatePairEloRaitings()
      @_initializeDragDrop()

    getPairs: () ->
      [
        @pairOneCt.currentView.collection
        @pairTwoCt.currentView.collection
      ]

    _initializeDragDrop: () ->
      pairOneView = @pairOneCt.currentView
      pairTwoView = @pairTwoCt.currentView

      @listenTo pairOneView, 'drag:dropped', (playerCard) =>
        model = playerCard.model

        pairOneView.collection.remove model
        pairTwoView.collection.add model

        @_checkReady()
        @_updatePairEloRaitings()

      @listenTo pairTwoView, 'drag:dropped', (playerCard) =>
        model = playerCard.model

        pairTwoView.collection.remove model
        pairOneView.collection.add model

        @_checkReady()
        @_updatePairEloRaitings()

    _getNextPairView: (players) ->
      pair = new PlayersCollection()
      pair.add [players.shift(), players.pop()]
      new PairWell(collection: pair)

    _updatePairEloRaitings: () ->
      pairOnePlayers = @pairOneCt.currentView.collection
      pairTwoPlayers = @pairTwoCt.currentView.collection
      pairOneElos = _.chain(pairOnePlayers.models).pluck('attributes').pluck('elo').value()
      pairTwoElos = _.chain(pairTwoPlayers.models).pluck('attributes').pluck('elo').value()

      @ui.pairOneElo.html @_average(pairOneElos)
      @ui.pairTwoElo.html @_average(pairTwoElos)

    _checkReady: () ->
      pairOnePlayers = @pairOneCt.currentView.collection
      pairTwoPlayers = @pairTwoCt.currentView.collection

      if pairOnePlayers.length is 2 and pairTwoPlayers.length is 2
        @trigger('ready')
      else
        @trigger('notready')

    _average:  (arr) ->
      _.reduce(arr, (memo, num) ->
        memo + num
      , 0) / arr.length
