define([
	'controllers/players_controller'

], function(PlayersController) {

	return {
        '/players': PlayersController
    };
});