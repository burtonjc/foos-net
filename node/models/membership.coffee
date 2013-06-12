define [
  'underscore'
  'mongoose'

], (_, mongoose) ->
  try
    return mongoose.model 'Membership'
  catch error

  Schema = mongoose.Schema
  MembershipSchema = new Schema
    rating:
      type: Number
      required: true
      ###
      Duplication alert:
        look at /node/helpers/elo.coffee#getDefaultRating
        must resolve circular dependency in order to use that method
      ###
      default: 1100
    player:
      type: Schema.Types.ObjectId
      ref: 'Player'
      required: true
    league:
      type: Schema.Types.ObjectId
      ref: 'League'
      required: true
    joinDate:
      type: Date
      default: Date.now
    isActive:
      type: Boolean
      default: true

  _.extend MembershipSchema.statics, 
    findByPlayerAndLeague: (playerId, leagueId, callback) ->
      @find({
        $and: [{
          player: playerId
        },{
          league: leagueId  
        }]
      }, callback)

    setRatingForPlayerAndLeague: (playerId, leagueId, elo, callback) ->
      @update({
        $and: [{
          player: playerId
        },{
          league: leagueId
        }]
      },{
        $set:
          elo: elo
      }, callback)

    # ensureMembershipsForPlayer: (playerId) ->
    #   League.findByPlayer(playerId).select('_id').lean().exec (err, leagues) =>
    #     leagueIds = _.chain(leagues).pluck('_id').unique().invoke('toString').value()

    #     Membership.find(player: playerId).select('league').lean().exec (err, ratings) =>
    #       ratingLeagueIds = _.chain(ratings).pluck('league').unique().invoke('toString').value()
    #       unratedLeagueIds = _.difference leagueIds, ratingLeagueIds
    #       for leagueId in unratedLeagueIds
    #         new Membership(
    #           league: mongoose.Types.ObjectId(leagueId)
    #           player: playerId
    #         ).save (err, rating) ->
    #           if err?
    #             console.log "\nerr"
    #             console.log err
    #           else
    #             console.log "rating"
    #             console.log rating

  MembershipSchema.index {player: 1, league: 1}

  mongoose.model 'Membership', MembershipSchema
  mongoose.model 'Membership'
