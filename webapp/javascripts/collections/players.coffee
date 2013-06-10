define [
  'backbone.loader'
  'models/player'

], (Backbone, Player) ->
  
  Backbone.Collection.extend
    url: '/players'
    model: Player

    comparator: (player) ->
      -player.get("elo")

    toJSON: ->
      (for model in @models
        model.id)
