define [
  'backbone'
  'models/league'

], (Backbone, League) ->
  
  Backbone.Collection.extend
    model: League

    url: () ->
      "players/#{@player.id}/leagues"

    player: null

    initialize: (opts) ->
      @player = opts.player