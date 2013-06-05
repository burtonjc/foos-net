define [
  '../models/player'
  'helpers/elo'
  'url'

], (Player, Elo, Url) ->

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
        winston.error error
        response.json err
      else
        response.json player
