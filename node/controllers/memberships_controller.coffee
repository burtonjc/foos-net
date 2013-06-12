define [
  'underscore'
  'models/membership'

], (_, Membership) ->

  query: (request, response, next) ->
    Membership.find()
      .select('_id rating player league joinDate isActive')
      .lean()
      .exec (err, data) ->
        response.json data

  get: (request, response, next) ->
    Membership.findById(request.params.id)
      .select('_id rating player league joinDate isActive')
      .lean()
      .exec (err, data) ->
        response.json data

  create: (request, response, next) ->
    body = JSON.parse request.body
    membership = new Membership
      player: body.player
      league: body.league

    membership.save (err) ->
      if err?
        console.log err
        response.json err
      else
        response.json membership

  update: (request, response, next) ->
    Membership.findById request.params.id, (err, membership) ->
      membership.set('isActive', request.params.isActive) if request.params.isActive?

      membership.save (err, membership) ->
        if err?
          console.log err
          response.json err
        else
          response.json membership
