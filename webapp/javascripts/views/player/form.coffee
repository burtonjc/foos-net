define [
  'jquery'
  'underscore'
  'marionette'
  'models/player'
  'tpl!templates/player/form.html'

], ($, _, Marionette, Player, PlayerFormTpl) ->
  Marionette.ItemView.extend
    template: PlayerFormTpl
    model: new Player

    ui:
      emailHelpIcon: '.email-help'

    initialize: ->
      @modelBinder = new Backbone.ModelBinder

    onClose: ->
      @model.clear()

    onRender: ->
      @modelBinder.bind @model, @el
      @ui.emailHelpIcon.tooltip
        placement: 'right'
        title: 'We currently only use your email for uniqueness and for Gravatar images.'
