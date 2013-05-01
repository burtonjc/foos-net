define [
  'underscore'
  'lib/elorating'
  'models/player'
], (_, EloRating, Player) ->
  getDefaultRating: () ->
    1100

  applyMatch: (match) ->
    Player.find(
      _id:
        $in: match.winners.concat match.losers
    ).select('_id elo').exec (arr, players)->
      winners = []
      losers = []
      winner_ids = _.invoke match.winners, 'toString'

      _.each players, (player) ->
        if _.contains(winner_ids, player._id.toString())
          winners.push player
        else
          losers.push player

      oldRatings =
        winners: me._getAvgRating(_.pluck(winners, 'elo')),
        losers: me._getAvgRating(_.pluck(losers, 'elo'))
      elo = new EloRating()

      elo.setNewSetings oldRatings.winners, oldRatings.losers, 1, 0
      newRatings = elo.getNewRatings()

      _.each winners, (player) ->
        totalPreElo = _.reduce _.pluck(winners, 'elo'), (p1, p2) ->
          p1 + p2
        gainRatio = (totalPreElo - player.elo) / totalPreElo
        totalGain = newRatings.winners - oldRatings.winners
        playerGain = totalGain * gainRatio
        newElo = Math.round(player.elo + playerGain)

        Player.findByIdAndUpdate player.id,
          $set:
            elo: newElo
        ,  (err, player) ->

      _.each losers, (player) ->
        totalPreElo = _.reduce _.pluck(losers, 'elo'), (p1, p2) ->
          p1 + p2
        gainRatio = (totalPreElo - player.elo) / totalPreElo
        totalGain = newRatings.losers - oldRatings.losers
        playerGain = totalGain * gainRatio
        newElo = Math.round(player.elo + playerGain)

        Player.findByIdAndUpdate player.id,
          $set:
            elo: newElo
        ,  (err, player) ->

  _getAvgRating: (ratings) ->
    _.reduce(ratings, (memo, num) ->
      memo + num
    , 0) / ratings.length
