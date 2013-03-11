define([
    '../models/player'

], function(Player) {

	return {
		get: function(request, response, next) {
			Player.find().limit(20).execFind(function(arr, data) {
				response.send(data);
			});
		},

		post: function(request, response, next) {
			var player = new Player();

			player.name = request.params.name;
			player.elo = 200;

            player.save(function() {
				response.send(request.body);
			});
		}
	};
});