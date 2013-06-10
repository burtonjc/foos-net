define [
  'backbone'
  'models/league'

], (Backbone, League) ->
  
  Backbone.Collection.extend
    url: '/leagues'
    model: League

    toJSON: ->
      (for model in @models
        model.id)
