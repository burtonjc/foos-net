define [
  'underscore'
  'mongoose'
  'models/league'

], (_, mongoose, League) ->
  try
    return mongoose.model 'Player'
  catch error

  trimAndLowerCase = (v) ->
    v.trim().toLowerCase()

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
    elo:
      type: Number
      required: true

  PlayerSchema.methods.updateLeagues = (leagues) ->
    leagueIds = _.map(_.toArray(leagues), mongoose.Types.ObjectId)
    
    # Update old leagues
    League.update({
      $and:[{
        _id:
          $nin: leagueIds
      },{
        players: @id
      }]
    },{
      $pull:
        players: @id
    },{multi: true}).lean().exec()

    # Update new leagues
    League.update({
      $and:[{
        _id:
          $in: leagueIds
      },{
        players:
          $ne: @id
      }]
    }, {
      $push:
        players: @id
    }, {multi: true}).lean().exec()


  mongoose.model 'Player', PlayerSchema
  mongoose.model 'Player'
