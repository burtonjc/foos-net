define [
  'underscore'
  'mongoose'
  '../models/player'
  '../models/league'
  'helpers/elo'
  'url'

], (_, mongoose, Player, League, Elo, Url) ->

  get: (request, response, next) ->
    Player
      .findById(request.params.id)
      .select('elo name email _id')
      .sort('-elo')
      .lean()
      .execFind (arr, data) ->
        response.json data

  query: (request, response, next) ->
    Player
      .find()
      .select('elo name email _id')
      .sort('-elo')
      .lean()
      .execFind (arr, data) ->
        response.json data

  create: (request, response, next) ->
    player = new Player request.params
    player.elo = Elo.getDefaultRating()

    player.save (err) ->
      if err?
        response.json err
      else
        response.json player

  update: (request, response, next) ->
    Player.findById(request.params.id)
      .exec (err, player) ->
        player.set 'name', request.params.name if request.params.name?
        player.updateLeagues(request.params.leagues) if request.params.leagues?

        # if request.params.leagues?
          # leagueIds = _.map(request.params.leagues, mongoose.Types.ObjectId)
          # League.update({
          #   $and:[{
          #     players: player.id
          #   },{
          #     _id:
          #       $nin: leagueIds
          #   }]
          # },{
          #   $pull:
          #     players: player.id
          # },{multi: true}).exec()

          # League.update({
          #   _id:
          #     $in: leagueIds
          # }, {
          #   $addToSet:
          #     players: player.id
          # }, {
          #   multi: true
          #   upsert: true
          # }).lean().exec()

        player.save (err) ->
          if err?
            console.log err
            response.json err
          else
            response.json player
