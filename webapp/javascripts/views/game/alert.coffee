define [
  'jquery'
  'underscore'
  'marionette'
  'tpl!templates/game/alert.html'

], ($, _, Marionette, AlertTpl) ->

  Marionette.ItemView.extend
    template: AlertTpl
    className: 'alert alert-error fade in'

    initialize: (opts) ->
      @templateHelpers = message: opts.message
