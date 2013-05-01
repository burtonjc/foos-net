define [
  '../models/player'
  'helpers/elo'
  'url'

], (Player, Elo, Url) ->

  get: (request, response, next) ->
    url_parts = Url.parse request.url, true

    Player.find().limit(url_parts.query.limit || 100).sort('-elo').execFind (arr, data) ->
      response.json data

  post: (request, response, next) ->
    player = new Player request.params
    player.elo = Elo.getDefaultRating()

    player.save (err) ->
      if err?
        response.json err
      else
        response.json player
