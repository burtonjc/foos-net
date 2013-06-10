define [
  'underscore'
  'models/match'
  'helpers/elo'

], (_, Match, Elo) ->

  query: (request, response, next) ->
    Match.find()
      .select('_id winners losers date league')
      .lean()
      .exec (arr, data) ->
        response.json data

  get: (request, response, next) ->
    Match.findById(request.params.id)
      .select('_id winners losers date league')
      .lean()
      .exec (arr, data) ->
        response.json data

  create: (request, response, next) ->
    body = JSON.parse request.body
    match = new Match
      league: body.league._id ? body.league
      winners: body.winners
      losers: body.losers

    match.save (err) ->
      if err?
        console.log err
        response.json err
      else
        Elo.applyMatch match
        response.json match
