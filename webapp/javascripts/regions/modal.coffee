define [
  'jquery'
  'underscore'
  'backbone.loader'

], ($, _, Backbone) ->

  Backbone.Marionette.Region.extend
    el: "#modal"

    onShow: (view) ->
      $(view.el).find('.modal').modal 'show'
