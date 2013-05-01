define [
  'underscore'
  'models/match'
  'helpers/elo'
  'url'

], (_, Match, Elo, Url) ->

  get: (request, response, next) ->
    url_parts = Url.parse request.url,true

    Match.find().limit(url_parts.query.limit || 20)
          .select('_id winners losers date')
          .populate('winners', 'name elo _id')
          .populate('losers', 'name elo _id')
          .exec (arr, data) ->
            response.json(data)

  post: (request, response, next) ->
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
