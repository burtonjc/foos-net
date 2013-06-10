define [
  'jquery'
  'underscore'
  'backbone.loader'

], ($, _, Backbone) ->
  
  Backbone.Model.extend
    urlRoot: '/matches'
    idAttribute: "_id"

    defaults:
      date: Date.now
      league: null
      winners: []
      losers: []
