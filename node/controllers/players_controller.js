define([
    '../models/player'

], function(Player) {

	return {
		get: function(request, response, next) {
			Player.find().limit(100).execFind(function(arr, data) {
				response.json(data);
			});
		},

		post: function(request, response, next) {
			var player = new Player();

			player.name = request.params.name;
			player.elo = 200;

            player.save(function(err) {
                if (err) {
                    return response.json(err);
                } else {
                    response.json(player);
                }
			});
		}
	};
});