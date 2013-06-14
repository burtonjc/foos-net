define [
  'underscore'
  'mongoose'
  'models/player'

], (_, mongoose, Player) ->

  get: (request, response, next) ->
    Player
      .findById(request.params.id)
      .select('name email _id')
      .sort('-elo')
      .lean()
      .execFind (arr, data) ->
        response.send data

  query: (request, response, next) ->
    Player
      .find()
      .select('name email _id')
      .sort('-elo')
      .lean()
      .execFind (arr, data) ->
        response.send data

  create: (request, response, next) ->
    body = JSON.parse request.body
    player = new Player
      name: body.name
      email: body.email

    player.save (err, player) ->
      if err?
        response.send err
      else
        response.send player

  update: (request, response, next) ->
    Player.findById request.params.id, (err, player) ->
      for path in ['name', 'email']
        do (path) ->
          if request.params[path]? and path.indexOf '_' isnt 0
            player.set path, request.params[path]

      player.save (err) ->
        if err?
          console.log err
          response.send err
        else
          response.send player
