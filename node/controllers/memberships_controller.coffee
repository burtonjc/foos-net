define [
  'underscore'
  'controllers/abstract_controller'
  'models/membership'
], (_, AbstractController, Membership) ->

  class MembershipsController extends AbstractController
    model: Membership

    defaultSelect: '_id rating player league joinDate isActive'
    defaultPopulate:
      league: '_id name description'
      player: '_id name email'
    defaultSort: '-rating'

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
      # WARNING: this is good, but need to be able to restrict certain fields (aka. rating)
      args = _.pick body, _.chain(Membership.schema.paths).keys().without('__v', '_id').value()
      console.log args
      record = new @model args

      record.save (err, doc) ->
        if err?
          console.log err
          response.json err
        else
          response.json doc

    update: (request, response, next) ->
      Membership.findById request.params.id, (err, membership) ->
        membership.set('isActive', request.params.isActive) if request.params.isActive?

        membership.save (err, membership) ->
          if err?
            console.log err
            response.json err
          else
            response.json membership

  MembershipsController.getInstance()
