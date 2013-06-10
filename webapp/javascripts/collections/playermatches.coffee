define [
  'backbone.loader'
  'models/match'

], (Backbone, Match) ->
  
  Backbone.Collection.extend
    model: Match

    url: () ->
      "players/#{@player.id}/matches"

    player: null

    initialize: (opts) ->
      @player = opts.player