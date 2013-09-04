define [
  'underscore'
  'controllers/abstract_controller'
  'models/match'
  'helpers/elo'
  'helpers/logger'

], (_, AbstractController, Match, Elo, logger) ->

  class MatchesController extends AbstractController
    query: (request, response, next) ->
      Match.find()
        .select('_id winners losers date league')
        .lean()
        .exec (arr, data) ->
          response.send data

    get: (request, response, next) ->
      Match.findById(request.params.id)
        .select('_id winners losers date league')
        .lean()
        .exec (arr, data) ->
          response.send data

    create: (request, response, next) ->
      body = JSON.parse request.body
      match = new Match
        league: body.league._id ? body.league
        winners: body.winners
        losers: body.losers

      match.save (err, match) ->
        if err?
          logger.error err
          response.send err
        else
          Elo.applyMatch match
          response.send match

  MatchesController.getInstance()
