define [
  'jquery'
  'underscore'
  'backbone.loader'

], ($, _, Backbone) ->
  
  Backbone.Model.extend
    urlRoot: '/leagues'
    idAttribute: "_id"

    defaults:
      name: ''
      description: ''
      players: []
