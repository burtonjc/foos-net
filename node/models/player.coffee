define [
  'underscore'
  'mongoose'
  'models/membership'

], (_, mongoose, Membership) ->
  try
    return mongoose.model 'Player'
  catch error

  trimAndLowerCase = (string) ->
    string.trim().toLowerCase()

  Schema = mongoose.Schema
  PlayerSchema = new Schema
    name:
      type: String
      required: true
    email:
      type: String
      required: true
      unique: true
      set: trimAndLowerCase

  _.extend PlayerSchema.methods,
    getLeagues: (callback) ->
      Membership
        .find(player:@id)
        .populate('league')
        .exec (err, membership) ->
          callback? err, _.pluck(membership, 'league')

  mongoose.model 'Player', PlayerSchema
  mongoose.model 'Player'
