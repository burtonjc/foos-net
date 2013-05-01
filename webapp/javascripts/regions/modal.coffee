define [
  'jquery'
  'underscore'
  'marionette'

], ($, _, Marionette) ->

  Marionette.Region.extend
    el: "#modal"

    onShow: (view) ->
      $(view.el).find('.modal').modal 'show'
