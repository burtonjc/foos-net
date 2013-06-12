define [
  'underscore'
  'models/league'

], (_, League) ->

  query: (request, response, next) ->
    League.find()
      .select('_id name description players')
      .lean()
      .exec (err, data) ->
        response.json(data)

  get: (request, response, next) ->
    League.findById(request.params.id)
      .select('_id name description players')
      .lean()
      .exec (err, data) ->
        response.json(data)

  create: (request, response, next) ->
    body = JSON.parse request.body
    league = new League
      name: body.name
      description: body.description

    league.save (err) ->
      if err?
        console.log err
        response.json err
      else
        response.json league

  update: (request, response, next) ->
    League.findById request.params.id, (err, league) ->
      for path in ['name', 'description']
        do (path) ->
          if request.params[path]? and path.indexOf '_' isnt 0
            league.set path, request.params[path]

      league.save (err) ->
        if err?
          console.log err
          response.json err
        else
          response.json league
