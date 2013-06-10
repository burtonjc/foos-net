define [
  'jquery'
  'underscore'
  'marionette'
  'foosnet'
  'views/modal/layout'

], ($, _, Marionette, FoosNet, ModalLayout) ->
  Marionette.Controller.extend
    sequence: []
    sequenceArgs: []
    _layout: null

    initialize: (opts) ->
      _.bindAll @
      @_layout = new ModalLayout
      FoosNet.modal.show @_layout
      @_seq = _.compact @sequence
      @_doSequence.apply(@, @sequenceArgs)

    _doSequence: () ->
      process = @_seq.shift()
      if process?
        args = _.toArray(arguments)
        args.push @_doSequence
        process.apply @, args
      else
        @close()

    showView: (view, opts={}) ->
      @currentView = view
      @_layout.show view, opts.header, opts.primaryBtn

      @listenToOnce @_layout, 'next', =>
        opts.submit.call(this)


    onClose: () ->
      modal = @_layout.$el.find '.modal'
      modal.on 'hidden', () =>
        @_layout.close()
        @_layout.remove()
      modal.modal 'hide'
      delete @_seq
