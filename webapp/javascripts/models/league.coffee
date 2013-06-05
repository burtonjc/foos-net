define [
  'jquery'
  'underscore'
  'backbone'
  'collections/players'

], ($, _, Backbone, PlayerCollection) ->
  Backbone.Model.extend
    urlRoot: '/leagues'
    idAttribute: "_id"

    defaults:
      name: ''
      description: ''
      players: new PlayerCollection
