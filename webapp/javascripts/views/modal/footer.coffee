define [
  'jquery'
  'underscore'
  'backbone.loader'
  'tpl!templates/modal/footer.html'
], ($, _, Backbone, GameFooterTpl) ->

  Backbone.Marionette.ItemView.extend
    template: GameFooterTpl

    ui:
      btnNext: '.btn-primary'
      btnCancel: '.btn.cancel'

    triggers:
      'click .btn-primary': 'next'

    initialize: () ->
      _.bindAll @

    deactivate: () ->
      @ui.btnNext.attr 'disabled', 'disabled'

    activate: () ->
      @ui.btnNext.removeAttr 'disabled'

    setPrimaryBtnText: (text) ->
      @ui.btnNext.html text
