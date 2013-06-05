define [
  'jquery'
  'underscore'
  'backbone'

], ($, _, Backbone) ->
  Backbone.Model.extend
    urlRoot: '/leagues'
    idAttribute: "_id"

    defaults:
      name: ''
      description: ''
