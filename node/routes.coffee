define [
  'controllers/players_controller',
	'controllers/matches_controller'

], (PlayersController, MatchesController) ->

  {
    '/players': PlayersController
    '/matches': MatchesController
  }
