define [
  'backbone'
  'models/player'

], (Backbone, Player) ->
  
  Backbone.Collection.extend
    url: '/players'
    model: Player

    comparator: (player) ->
      -player.get("elo")
