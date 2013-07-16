define [
  'underscore'
  'controllers/abstract_controller'
  'models/league'
], (_, AbstractController, League) ->

  class LeaguePlayersController extends AbstractController
    query: (request, response, next) ->
      League.findById request.params.id, (err, league) ->
        league.getPlayers (err, players) ->
          response.json players

  LeaguePlayersController.getInstance()
