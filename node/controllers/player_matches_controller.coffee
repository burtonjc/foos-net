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
    .populate('winners', '_id')
    .populate('losers', '_id')
    .exec (arr, data) ->
      response.json(data)
