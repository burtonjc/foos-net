define [
  'underscore'
  'mongoose'
  'models/player'
  'models/membership'

], (_, mongoose, Player, Membership) ->
  try
    return mongoose.model 'League'
  catch error

  Schema = mongoose.Schema
  LeagueSchema = new Schema
    name:
      type: String
      required: true
    description:
      type: String

  _.extend LeagueSchema.methods,
    getPlayers: (callback) ->
      Membership
        .find(league:@id)
        .populate('player')
        .exec (err, membership) ->
          callback? err, _.pluck(membership, 'player')


  mongoose.model 'League', LeagueSchema
  mongoose.model 'League'
