define [
  'jquery'
  'underscore'
  'controllers/modal'
  'views/ui/chooser'
  'views/game/pairchooser/pairchooser'
  'views/game/resultsrecorder'
  'views/league/list'
  'domain/cache'

], ($, _, ModalController, ChooserView, PairChooser, ResultsRecorder, LeagueListView, DomainCache) ->
  ModalController.extend
    sequence: [
      (next) ->
        leagueView = new LeagueListView
        leagueChooser = new ChooserView
          searchPrompt: 'Search for a league...'
          count: 1
          collectionType: 'leagues'
          modelStageView: leagueView

        @showView leagueChooser,
          header: 'Choose your league...'
          submit: ->
            next leagueView.collection.at(0)

      (league, next) ->
        pairChooser = new PairChooser
          league: league
        playerchooser = new ChooserView
          searchPrompt: 'Search for players...'
          displayAttribute: 'player.name'
          count: 4
          collectionType: 'leaguememberships'
          collectionOpts:
            league: league
          modelStageView: pairChooser

        @showView playerchooser,
          header: 'Choose your players...'
          submit: ->
            next league, pairChooser.getPairs()

      (league, pairs, next) ->
        recorder = new ResultsRecorder(pairs: pairs)
        @showView recorder,
          header: 'Record your results...'
          primaryBtn: 'Finish'
          submit: ->
            results = recorder.getResults()
            Match = DomainCache.getModel 'match'
            new Match({
                league: league.id
                winners: results.winners.pluck('_id')
                losers: results.losers.pluck('_id')
              }).save(null,{
                success: ->
                  next()
              })
    ]
