define [
  'jquery'
  'underscore'
  'marionette'
  'views/modal/layout'
  'views/game/playerchooser'
  'views/game/header'
  'views/game/footer'
  'views/game/alert'
  'views/game/pairchooser/pairchooser'
  'views/game/resultsrecorder'
  'models/match'

], ($, _, Marionette, ModalLayout, PlayerChooser, GameHeader, GameFooter, GameAlert, PairChooser, ResultsRecorder, Match) ->
  Marionette.Controller.extend

    initialize: (opts) ->
      @region = opts.region

    playGame: () ->
      @layout = new ModalLayout()
      @region.show @layout

      @layout.header.show new GameHeader()
      @layout.footer.show new GameFooter()

      @_choosePlayers()

    _choosePlayers: () ->
      playerchooser = new PlayerChooser()
      footer = @layout.footer.currentView

      @_transitionView "Choose your players...", playerchooser

      footer.once 'next', () =>
        @_choosePairs playerchooser.collection

    _choosePairs: (players) ->
      footer = @layout.footer.currentView
      pairchooser = new PairChooser(players: players)

      @_transitionView "Choose your pairs...", pairchooser

      footer.once 'next', () =>
        @_recordResults pairchooser.getPairs()

    _recordResults: (pairs) ->
      footer = @layout.footer.currentView
      recorder = new ResultsRecorder pairs: pairs

      footer.ui.btnNext.html "Finish"

      @_transitionView "Record your results...", recorder

      footer.once 'next', () =>
        results = recorder.getResults()
        match = new Match(results)

        match.save()

        @_closeOutModal()

    _transitionView: (headerText, view) ->
      header = @layout.header.currentView
      footer = @layout.footer.currentView

      @stopListening @layout.body.currentView

      header.setLabel headerText

      @listenTo view, 'error', (message) =>
        @layout.alert.show new GameAlert(message: message)

      @listenTo view, 'notready', footer.deactivate
      @listenTo view, 'ready', footer.activate
      @layout.body.show view

    _closeOutModal: () ->
      modal = $(@layout.el).find '.modal'

      modal.on 'hidden', () =>
        @layout.destroyRegions()
        @layout.remove()

      modal.modal 'hide'
