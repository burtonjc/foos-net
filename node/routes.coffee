define [
  'controllers/leagues_controller'
  'controllers/league_players_controller'
  'controllers/matches_controller'
  'controllers/players_controller'
  'controllers/player_leagues_controller'
  'controllers/player_matches_controller'

], (LeaguesController, LeaguePlayersController, MatchesController, PlayersController, PlayerLeaguesController, PlayerMatchesController) ->

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
      'actions': ['get', 'update']

    '/players/:id/leagues':
      'controller': PlayerLeaguesController
      'actions': ['query']
    '/players/:id/matches':
      'controller': PlayerMatchesController
      'actions': ['query']
  }
