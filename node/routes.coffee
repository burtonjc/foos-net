define [
	'controllers/matches_controller'
  'controllers/players_controller'
  'controllers/player_matches_controller'

], (MatchesController, PlayersController, PlayerMatchesController) ->

  {
    '/matches':
      'controller': MatchesController
      'actions': ['create', 'query']
    '/matches/:id':
      'controller': MatchesController
      'actions': ['get']

    '/players':
      'controller': PlayersController
      'actions': ['create', 'query']
    '/players/:id':
      'controller': PlayersController
      'actions': ['get']

    '/players/:id/matches':
      'controller': PlayerMatchesController
      'actions': ['query']
  }
