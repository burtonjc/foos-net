define [
  'mongoose'

], (mongoose) ->
  try
    return mongoose.model 'Match'
  catch error

  Schema = mongoose.Schema
  MatchSchema = new Schema
    date:
      type: Date
      'default': Date.now
    league:
      type: Schema.Types.ObjectId
      ref: 'League'
      required: true
    winners: [{
      type: Schema.Types.ObjectId
      ref: 'Player'
    }]
    losers: [{
      type: Schema.Types.ObjectId
      ref: 'Player'
    }]

  mongoose.model 'Match', MatchSchema
  mongoose.model 'Match'
