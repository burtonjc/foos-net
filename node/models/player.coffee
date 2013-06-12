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

  # _.extend PlayerSchema.methods,
  #   ensureRatingsForLeagues: ->
  #     League.findByPlayer(@id).select('_id').lean().exec (err, leagues) =>
  #       leagueIds = _.chain(leagues).pluck('_id').unique().invoke('toString').value()
  #       Rating.find(player: @id).select('league').lean().exec (err, ratings) =>
  #         ratingLeagueIds = _.chain(ratings).pluck('league').unique().invoke('toString').value()
  #         unratedLeagueIds = _.difference leagueIds, ratingLeagueIds
  #         for leagueId in unratedLeagueIds
  #           new Rating(
  #             league: mongoose.Types.ObjectId(leagueId)
  #             player: @id
  #           ).save (err, rating) ->
  #             if err?
  #               console.log "\nerr"
  #               console.log err
  #             else
  #               console.log "rating"
  #               console.log rating

  #   updateLeagues = (leagues) ->
  #     leagueIds = _.chain(leagues).toArray().map(mongoose.Types.ObjectId).value()
      
  #     # Update old leagues
  #     League.update({
  #       $and:[{
  #         _id:
  #           $nin: leagueIds
  #       },{
  #         players: @id
  #       }]
  #     },{
  #       $pull:
  #         players: @id
  #     },{multi: true}).lean().exec()

  #     # Update new leagues
  #     League.update({
  #       $and:[{
  #         _id:
  #           $in: leagueIds
  #       },{
  #         players:
  #           $ne: @id
  #       }]
  #     }, {
  #       $push:
  #         players: @id
  #     }, {multi: true}).lean().exec()

  #     @ensureRatingsForLeagues()


  mongoose.model 'Player', PlayerSchema
  mongoose.model 'Player'
