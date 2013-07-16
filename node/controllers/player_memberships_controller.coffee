define [
  'underscore'
  'controllers/abstract_controller'
  'models/membership'
], (_, AbstractController, Membership) ->

  class PlayerMembershipsController extends AbstractController
    model: Membership

    query: (request, response, next) ->
      Membership
        .find(player: request.params.id)
        .populate('league', 'name description _id')
        .populate('player', 'name email _id')
        .sort('-rating')
        .lean()
        .exec (err, memberships) ->
          response.json memberships

  PlayerMembershipsController.getInstance()
