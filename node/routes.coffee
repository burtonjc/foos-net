define [
  'controllers/players_controller'
	'controllers/matches_controller'
  'controllers/player_matches_controller'

], (PlayersController, MatchesController, PlayerMatchesController) ->

  {
    '/players': PlayersController
    '/matches': MatchesController
    '/players/:id/matches': PlayerMatchesController
  }
