define [
  'jquery'
  'underscore'
  'marionette'
  'tpl!templates/modal/layout.html'

], ($, _, Marionette, ModalLayoutTpl) ->

  Marionette.Layout.extend
    regions:
      header: '#modalHeader'
      alert: '#modalAlert'
      body: '#modalBody'
      footer: '#modalFooter'

    template: ModalLayoutTpl
    templateHelpers: {}

    prop: 'prop'

    initialize: (opts) ->
      @templateHelpers = _.defaults(opts, @templateHelpers);
