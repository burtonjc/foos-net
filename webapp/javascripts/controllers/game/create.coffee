define [
  'jquery'
  'underscore'
  'controllers/modal'
  'views/ui/chooser'
  'views/game/pairchooser/pairchooser'
  'views/game/resultsrecorder'
  'models/match'

], ($, _, ModalController, ChooserView, PairChooser, ResultsRecorder, Match) ->
  ModalController.extend
    sequence: [
      (next) ->
        pairChooser = new PairChooser
        playerchooser = new ChooserView
          searchPrompt: 'Search for players...'
          count: 4
          collectionPath: 'collections/players'
          modelStage: pairChooser

        @showView playerchooser,
          header: 'Choose your players...'
          submit: ->
            next pairChooser.getPairs()

      (pairs, next) ->
        recorder = new ResultsRecorder(pairs: pairs)
        @showView recorder,
          header: 'Record your results...'
          primaryBtn: 'Finish'
          submit: ->
            match = new Match recorder.getResults()
            match.save null,
              success: ->
                next()
    ]
