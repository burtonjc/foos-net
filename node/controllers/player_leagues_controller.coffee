define [
  'underscore'
  'models/league'
  'url'

], (_, League, Url) ->

  query: (request, response, next) ->
    League.find(players: request.params.id)
          .select('_id name description players')
          .lean()
          .exec (arr, data) ->
            response.json(data)
