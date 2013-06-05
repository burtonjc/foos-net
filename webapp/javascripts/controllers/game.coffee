define [
  'jquery'
  'underscore'
  'marionette'
  'views/modal/layout'
  'views/game/playerchooser'
  'views/game/pairchooser/pairchooser'
  'views/game/resultsrecorder'
  'models/match'

], ($, _, Marionette, ModalLayout, PlayerChooser, PairChooser, ResultsRecorder, Match) ->
  Marionette.Controller.extend

    layout: null

    initialize: (opts) ->
      @layout = new ModalLayout()
      opts.region.show @layout

      @_choosePlayers()

    _choosePlayers: () ->
      playerchooser = new PlayerChooser()

      @layout.show playerchooser, "Choose your players..."

      @listenToOnce @layout, 'next', () =>
        @_recordResults playerchooser.getPairs()

    _recordResults: (pairs) ->
      recorder = new ResultsRecorder(pairs: pairs)

      @layout.show recorder, "Record your results...", "Finish"

      @listenToOnce @layout, 'next', () =>
        results = recorder.getResults()
        match = new Match(results)

        match.save()

        @_closeOutModal()

    _closeOutModal: () ->
      modal = $(@layout.el).find '.modal'

      modal.on 'hidden', () =>
        @layout.close()
        @layout.remove()

      modal.modal 'hide'
