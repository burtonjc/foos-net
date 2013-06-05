define [
  'underscore'
  'models/league'
  'models/player'
  'url'

], (_, League, Player, Url) ->

  query: (request, response, next) ->
    Player.find(
      players:
        $all: [request.params.id]
    )
    .select('_id name email elo')
    .lean()
    .exec (arr, data) ->
      response.json(data)
