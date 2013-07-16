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

  MembershipSchema.index {player: 1, league: 1}

  mongoose.model 'Membership', MembershipSchema
  mongoose.model 'Membership'
