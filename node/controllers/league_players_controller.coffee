define [
  'underscore'
  'models/league'

], (_, League) ->

  query: (request, response, next) ->
    League.findById request.params.id, (err, league) ->
      league.getPlayers (err, players) ->
        response.json players
