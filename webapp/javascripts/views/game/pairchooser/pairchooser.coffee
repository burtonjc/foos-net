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

    collection: new (DomainCache.getCollection('players'))()
    vent: null

    collectionEvents:
      'add': '_divvyUpPairs'
      'remove': '_divvyUpPairs'

    initialize: (opts) ->
      @vent = opts.vent ? _.extend {}, Backbone.Events
      @vent.on 'player:remove', (model) => @trigger 'model:removed', model
      @vent.on 'player:move', (model) => @trigger 'model:moved', model
      @league = opts.league ? null

      @collection.comparator = (player) =>
        membership = player.get('memberships').findWhere(league: @league)
        if membership?
          -membership.get('rating')

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
        collection: new (DomainCache.getCollection('players'))()
        league: @league
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
      _.compact [
        @pairOneCt?.currentView.collection
        @pairTwoCt?.currentView.collection
      ]

    _divvyUpPairs: () ->
      @_fetchPlayerMemberships().done =>
        @collection.sort()
        pairs = @getPairs()
        for pair in pairs
          pair.reset()

        @collection.each (player, idx) =>  
          if idx is 0 or idx is (@collection.length - 1)
            pairs[0].add player
          else
            pairs[1].add player

        @_updatePairEloRaitings()
        @_checkReady()

    # this is gross, but this is hackathon...what can i say
    _fetchPlayerMemberships: ->
      d = new $.Deferred()
      counter = 0
      @collection.each (player) =>
        memberships = player.get 'memberships'
        if memberships.length
          d.resolve() if ++counter is @collection.length
          return
        else
          player.get('memberships').fetch().done (memberships) =>
            leagueMembership = player.get('memberships').where(league: @league)[0]
            player.set('rating', leagueMembership.get('rating'))
            d.resolve() if ++counter is @collection.length

      d.promise()


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
