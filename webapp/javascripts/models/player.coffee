define [
  'jquery'
  'underscore'
  'backbone'
], ($, _, Backbone) ->

  Backbone.Model.extend
    urlRoot: '/players'
    idAttribute: "_id"

    defaults:
      elo: 1100
