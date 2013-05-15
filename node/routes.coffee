define [
	'controllers/matches_controller'
  'controllers/players_controller'
  'controllers/player_matches_controller'

], (MatchesController, PlayersController, PlayerMatchesController) ->

  {
    '/matches': MatchesController
    '/players': PlayersController
    '/players/:id/matches': PlayerMatchesController
  }
