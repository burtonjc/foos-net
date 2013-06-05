define [
  'controllers/leagues_controller'
  'controllers/league_players_controller'
  'controllers/matches_controller'
  'controllers/players_controller'
  'controllers/player_matches_controller'

], (LeaguesController, LeaguePlayersController, MatchesController, PlayersController, PlayerMatchesController) ->

  {
    '/leagues':
      'controller': LeaguesController
      'actions': ['create', 'query']
    '/leagues/:id':
      'controller': LeaguesController
      'actions': ['get', 'update']

    '/leagues/:id/players':
      'controller': LeaguePlayersController
      'actions': ['query']

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
