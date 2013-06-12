define [
  'underscore'
  'models/player'

], (_, Player) ->

  query: (request, response, next) ->
    Player.findById request.params.id, (err, player) ->
      player.getLeagues (err, leagues) ->
        response.json leagues
