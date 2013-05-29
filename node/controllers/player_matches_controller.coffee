define [
  'underscore'
  'models/match'
  'models/player'
  'url'

], (_, Match, Player, Url) ->

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
