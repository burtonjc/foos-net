define [
  'mongoose'

], (mongoose) ->
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
    players: [{
      type: Schema.Types.ObjectId
      ref: 'Player'
    }]

  mongoose.model 'League', LeagueSchema
  mongoose.model 'League'
