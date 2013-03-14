define([
    'controllers/players_controller',
	'controllers/matches_controller'

], function(PlayersController, MatchesController) {
	return {
        '/players': PlayersController,
        '/matches': MatchesController
    };
});