define([
    '../models/player',
    'helpers/elo',
    'url'

], function(Player, Elo, Url) {

	return {
		get: function(request, response, next) {
            var url_parts = Url.parse(request.url,true);

			Player.find().limit(url_parts.query.limit || 20).sort('-elo').execFind(function(arr, data) {
				response.json(data);
			});
		},

		post: function(request, response, next) {
			var player = new Player(request.params);
			player.elo = Elo.getDefaultRating();

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