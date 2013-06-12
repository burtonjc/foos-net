define [
  'controllers/leagues_controller'
  'controllers/league_players_controller'
  'controllers/league_memberships_controller'
  'controllers/matches_controller'
  'controllers/memberships_controller'
  'controllers/players_controller'
  'controllers/player_leagues_controller'
  'controllers/player_matches_controller'
  'controllers/player_memberships_controller'

], (LeaguesController, LeaguePlayersController, LeagueMembershipsController, MatchesController, MembershipsController, PlayersController, PlayerLeaguesController, PlayerMatchesController, PlayerMembershipsController) ->

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
    '/leagues/:id/memberships':
      'controller': LeagueMembershipsController
      'actions': ['query']

    '/matches':
      'controller': MatchesController
      'actions': ['create', 'query']
    '/matches/:id':
      'controller': MatchesController
      'actions': ['get']

    '/memberships':
      'controller': MembershipsController
      'actions': ['create', 'query']
    '/memberships/:id':
      'controller': MembershipsController
      'actions': ['get', 'update']

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
    '/players/:id/memberships':
      'controller': PlayerMembershipsController
      'actions': ['query']
  }
