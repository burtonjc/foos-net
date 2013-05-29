define [
  'underscore'
  'models/match'
  'helpers/elo'
  'url'

], (_, Match, Elo, Url) ->

  query: (request, response, next) ->
    Match.find()
      .select('_id winners losers date')
      .lean()
      .exec (arr, data) ->
        response.json(data)

  get: (request, response, next) ->
    Match.findById(request.params.id)
      .select('_id winners losers date')
      .lean()
      .exec (arr, data) ->
        response.json(data)

  create: (request, response, next) ->
    match = new Match()
    body = JSON.parse request.body

    _.each body.winners, (winner)->
      match.winners.push winner._id

    _.each body.losers, (loser)->
      match.losers.push loser._id

    match.save (err) ->
      if err?
        console.log err
        return response.json err
      else
        Elo.applyMatch match
        response.json match
