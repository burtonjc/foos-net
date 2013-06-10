define [
  'jquery'
  'underscore'
  'controllers/modal'
  'views/ui/chooser'
  'views/game/pairchooser/pairchooser'
  'views/game/resultsrecorder'
  'views/league/list'
  'models/match'

], ($, _, ModalController, ChooserView, PairChooser, ResultsRecorder, LeagueListView, Match) ->
  ModalController.extend
    sequence: [
      (next) ->
        leagueView = new LeagueListView
        leagueChooser = new ChooserView
          searchPrompt: 'Search for a league...'
          count: 1
          collectionPath: 'collections/leagues'
          modelStage: leagueView

        @showView leagueChooser,
          header: 'Choose your league...'
          submit: ->
            next leagueView.collection.at(0)

      (league, next) ->
        pairChooser = new PairChooser
        playerchooser = new ChooserView
          searchPrompt: 'Search for players...'
          count: 4
          collectionPath: 'collections/leagueplayers'
          collectionOpts:
            league: league
          modelStage: pairChooser

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
            new Match().save({
                league: league
                winners: results.winners
                losers: results.losers
              },
              success: ->
                next()
            )
    ]
