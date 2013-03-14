define([
    '../models/player',
    'url'

], function(Player, Url) {

	return {
		get: function(request, response, next) {
            var url_parts = Url.parse(request.url,true);

			Player.find().limit(url_parts.query.limit || 20).execFind(function(arr, data) {
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