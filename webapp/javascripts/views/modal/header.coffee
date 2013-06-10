define [
  'jquery'
  'underscore'
  'backbone.loader'
  'tpl!templates/modal/header.html'

], ($, _, Backbone, HeaderTpl) ->

  Backbone.Marionette.ItemView.extend
    template: HeaderTpl

    ui:
      label: '.header-label'

    setLabel: (label) ->
      @ui.label.html label
