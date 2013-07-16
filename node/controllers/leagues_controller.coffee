define [
  'underscore'
  'controllers/abstract_controller'
  'models/league'
], (_, AbstractController, League) ->

  class LeaguesController extends AbstractController
    query: (request, response, next) ->
      League.find()
        .select('_id name description players')
        .lean()
        .exec (err, data) ->
          response.send data

    get: (request, response, next) ->
      League.findById(request.params.id)
        .select('_id name description players')
        .lean()
        .exec (err, data) ->
          response.send data

    create: (request, response, next) ->
      body = JSON.parse request.body
      league = new League
        name: body.name
        description: body.description

      league.save (err) ->
        if err?
          console.log err
          response.send err
        else
          response.send league

    update: (request, response, next) ->
      League.findById request.params.id, (err, league) ->
        for path in ['name', 'description']
          do (path) ->
            if request.params[path]? and path.indexOf '_' isnt 0
              league.set path, request.params[path]

        league.save (err) ->
          if err?
            console.log err
            response.send err
          else
            response.send league

  LeaguesController.getInstance()
