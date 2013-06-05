define [
  'jquery'
  'underscore'
  'controllers/modal'
  'views/game/playerchooser'
  'views/game/pairchooser/pairchooser'
  'views/game/resultsrecorder'
  'models/match'

], ($, _, ModalController, PlayerChooser, PairChooser, ResultsRecorder, Match) ->
  ModalController.extend
    sequence: [
      ->
        playerchooser = new PlayerChooser()
        @showView playerchooser,
          header: 'Choose your players...'
          submit: (next) ->
            next playerchooser.getPairs()

      (pairs) ->
        recorder = new ResultsRecorder(pairs: pairs)
        @showView recorder,
          header: 'Record your results...'
          primaryBtn: 'Finish'
          submit: (next) ->
            match = new Match recorder.getResults()
            match.save null,
              success: ->
                next()
    ]
