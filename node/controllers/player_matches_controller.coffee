define [
  'underscore'
  'controllers/abstract_controller'
  'models/match'
  'models/player'
  'url'
], (_, AbstractController, Match, Player, Url) ->

  class PlayerMatchesController extends AbstractController
    query: (request, response, next) ->
      Match.find(
        $or:[{
            winners:
              $all: [request.params.id]
          },{
            losers:
              $all: [request.params.id]
          }]
      )
      .select('_id winners losers date')
      .lean()
      .exec (arr, data) ->
        response.json(data)

  PlayerMatchesController.getInstance()
