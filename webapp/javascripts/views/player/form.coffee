define [
  'jquery'
  'underscore'
  'backbone.loader'
  'models/player'
  'tpl!templates/player/form.html'

], ($, _, Backbone, Player, PlayerFormTpl) ->
  Backbone.Marionette.ItemView.extend
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
