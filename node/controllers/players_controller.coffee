define [
  'underscore'
  'controllers/abstract_controller'
  'models/player'
], (_, AbstractController, Player) ->

  class PlayersController extends AbstractController
    model: Player
    defaultSelect: '_id name email'

    query: (request, response, next) ->
      @buildQuery()
        .lean()
        .exec (err, data) ->
          response.send data

    get: (request, response, next) ->
      @buildQuery(request.params.id)
        .lean()
        .exec (err, data) ->
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

  PlayersController.getInstance()
