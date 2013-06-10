define [
  'underscore'
  'models/league'
  'models/player'
  'url'

], (_, League, Player, Url) ->

  query: (request, response, next) ->
    League.findById(request.params.id)
          .select('players')
          .populate('players')
          .exec (err, data) ->
            if err?
              console.log err
              response.json err
            else
              response.json data.players
