define [
  'underscore'
  'lib/elorating'
  'models/membership'
], (_, EloRating, Membership) ->
  getDefaultRating: () ->
    1100

  applyMatch: (match) ->
    Membership.find
      $and: [{
        player:
          $in: match.winners.concat match.losers
      },{
        league: match.league
      }]
    , (err, memberships) =>
      winners = []
      losers = []
      winnerIds = _.invoke match.winners, 'toString'

      _.each memberships, (membership) ->
        if _.contains(winnerIds, membership.player.toString())
          winners.push membership
        else
          losers.push membership

      oldRatings =
        winners: @_getAvgRating(_.pluck(winners, 'rating')),
        losers: @_getAvgRating(_.pluck(losers, 'rating'))

      elo = new EloRating()
      elo.setNewSetings oldRatings.winners, oldRatings.losers, 1, 0
      newRatings = elo.getNewRatings()

      _.each winners, (membership) ->
        totalPreElo = _.reduce _.pluck(winners, 'rating'), (p1, p2) ->
          p1 + p2
        gainRatio = (totalPreElo - membership.rating) / totalPreElo
        totalGain = newRatings.winners - oldRatings.winners
        playerGain = totalGain * gainRatio
        newElo = Math.round(membership.rating + playerGain)

        membership.set 'rating', newElo
        membership.save()

      _.each losers, (membership) ->
        totalPreElo = _.reduce _.pluck(losers, 'rating'), (p1, p2) ->
          p1 + p2
        ###
        i think this next line should be gainRation = 1 - ((totalPreElo - membership.rating) / totalPreElo)
        ###
        gainRatio = (totalPreElo - membership.rating) / totalPreElo
        totalGain = newRatings.losers - oldRatings.losers
        playerGain = totalGain * gainRatio
        newElo = Math.round(membership.rating + playerGain)

        membership.set 'rating', newElo
        membership.save()

  _getAvgRating: (ratings) ->
    _.reduce(ratings, (memo, num) ->
      memo + num
    , 0) / ratings.length
