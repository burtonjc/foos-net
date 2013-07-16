define [
  'underscore'
  'controllers/abstract_controller'
  'models/player'
], (_, AbstractController, Player) ->

  class PlayerLeaguesController extends AbstractController
    query: (request, response, next) ->
      Player.findById request.params.id, (err, player) ->
        player.getLeagues (err, leagues) ->
          response.json leagues

  PlayerLeaguesController.getInstance()
