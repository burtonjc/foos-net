define [
  'backbone'
  'models/player'

], (Backbone, Player) ->
  
  Backbone.Collection.extend
    model: Player

    url: () ->
      "leagues/#{@league.id}/players"

    league: null

    initialize: (opts) ->
      @league = opts.league