define [
  'jquery'
  'underscore'
  'marionette'
  'tpl!templates/game/footer.html'
], ($, _, Marionette, GameFooterTpl) ->

  Marionette.ItemView.extend
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
