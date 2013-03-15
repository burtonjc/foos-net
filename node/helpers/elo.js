define([
    'underscore',
    'lib/elorating',
    'models/player'
], function(_, EloRating, Player) {
    return {
        getDefaultRating: function() {
            return 1100;
        },

        applyMatch: function(match) {
            var me = this;
            Player.find({_id: {$in: match.winners.concat(match.losers) }}).select('_id elo').exec(function(arr, players){
                var winners = [],
                    losers = [],
                    winner_ids = _.invoke(match.winners, 'toString');

                _.each(players, function(player) {
                    if (_.contains(winner_ids, player._id.toString())) {
                        winners.push(player);
                    } else {
                        losers.push(player);
                    }
                });

                var oldRatings = {
                        winners: me._getAvgRating(_.pluck(winners, 'elo')),
                        losers: me._getAvgRating(_.pluck(losers, 'elo'))
                    },
                    elo = new EloRating(),
                    newRatings;

                    elo.setNewSetings(oldRatings.winners, oldRatings.losers, 1, 0);
                    newRatings = elo.getNewRatings();

                _.each(winners, function(player) {
                    var totalPreElo = _.reduce(_.pluck(winners, 'elo'), function(p1, p2) {
                            return p1 + p2;
                        }),
                        gainRatio = (totalPreElo - player.elo) / totalPreElo,
                        totalGain = newRatings.winners - oldRatings.winners,
                        playerGain = totalGain * gainRatio,
                        newElo = Math.round(player.elo + playerGain);

                    Player.findByIdAndUpdate(player.id, { $set: { elo: newElo }}, function (err, player) {
                    });
                });

                _.each(losers, function(player) {
                    var totalPreElo = _.reduce(_.pluck(losers, 'elo'), function(p1, p2) {
                            return p1 + p2;
                        }),
                        gainRatio = (totalPreElo - player.elo) / totalPreElo,
                        totalGain = newRatings.losers - oldRatings.losers,
                        playerGain = totalGain * gainRatio,
                        newElo = Math.round(player.elo + playerGain);

                    Player.findByIdAndUpdate(player.id, { $set: { elo: newElo }}, function (err, player) {
                    });
                });
            });

        },

        _getAvgRating: function(ratings) {
            return _.reduce(ratings, function(memo, num) {
                return memo + num;
            }, 0) / ratings.length;
        }
    };
});
