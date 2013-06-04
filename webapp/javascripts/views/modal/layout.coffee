define [
  'jquery'
  'underscore'
  'marionette'
  'views/modal/header'
  'views/modal/footer'
  'views/modal/alert'
  'tpl!templates/modal/layout.html'

], ($, _, Marionette, ModalHeader, ModalFooter, ModalAlert, ModalLayoutTpl) ->

  Marionette.Layout.extend
    regions:
      header: '#modalHeader'
      alert: '#modalAlert'
      body: '#modalBody'
      footer: '#modalFooter'

    template: ModalLayoutTpl
    templateHelpers: {}

    prop: 'prop'

    currentView: null

    initialize: (opts) ->
      _.bindAll @
      @templateHelpers = _.defaults(opts, @templateHelpers);

    onRender: ->
      @header.show new ModalHeader
      @footer.show new ModalFooter

      @listenTo @footer.currentView, 'next', -> @trigger 'next'

    show: (view, headerLabel, footerPrimaryBtnText) ->
      return false unless view? and not _.isString(view)

      @_listenToView view

      @header.currentView.setLabel(headerLabel) if headerLabel?
      @footer.currentView.setPrimaryBtnText(footerPrimaryBtnText) if footerPrimaryBtnText?

      @currentView = view
      @body.show view

    _listenToView: (view) ->
      @stopListening @currentView if @currentView?
      @listenTo view, 'error', (message) =>
        @alert.show new ModalAlert(message: message)

      @listenTo view, 'notready', @footer.currentView.deactivate
      @listenTo view, 'ready', @footer.currentView.activate
