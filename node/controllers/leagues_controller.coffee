define [
  'underscore'
  'models/league'

], (_, League) ->

  defaultFetch: '_id name description players'

  query: (request, response, next) ->
    League.find()
      .select(@defaultFetch)
      .lean()
      .exec (err, data) ->
        response.json(data)

  get: (request, response, next) ->
    League.findById(request.params.id)
      .select(@defaultFetch)
      .lean()
      .exec (err, data) ->
        response.json(data)

  create: (request, response, next) ->
    body = JSON.parse request.body
    league = new League(body)

    _.each body.players, (player)->
      league.players.push player._id

    league.save (err) ->
      if err?
        console.log err
        return response.json err
      else
        response.json league

  update: (request, response, next) ->
    League.findById(request.params.id)
      .exec (err, league) ->
        for attr in ['name', 'description', 'players']
          do (attr) ->
            league.set attr, request.params[attr] if request.params[attr]?

        league.save (err) ->
          if err?
            console.log err
            return response.json err
          else
            response.json league
