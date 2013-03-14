define([
    'underscore',
    'models/match',
    'url'

], function(_, Match, Url) {

    return {
        get: function(request, response, next) {
            var url_parts = Url.parse(request.url,true);

            Match.find().limit(url_parts.query.limit || 20)
                        .select('_id winners losers date')
                        .populate('winners', 'name elo _id')
                        .populate('losers', 'name elo _id')
                        .exec(function(arr, data) {
                            response.json(data);
                        });
        },

        post: function(request, response, next) {
            var match = new Match(),
                body = JSON.parse(request.body);

            _.each(body.winners, function(winner){
                match.winners.push(winner._id);
            });

            _.each(body.losers, function(loser){
                match.losers.push(loser._id);
            });

            match.save(function(err) {
                if (err) {
                    console.log(err);
                    return response.json(err);
                } else {
                    response.json(match);
                }
            });
        }
    };
});