define [
  'jquery'
  'underscore'
  'backbone.loader'
  'tpl!templates/modal/alert.html'

], ($, _, Backbone, AlertTpl) ->

  Backbone.Marionette.ItemView.extend
    template: AlertTpl
    className: 'alert alert-error fade in'

    initialize: (opts) ->
      @templateHelpers = message: opts.message
