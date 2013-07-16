define [
  'underscore'
  'controllers/abstract_controller'
  'models/membership'
], (_, AbstractController, Membership) ->

  class LeagueMembershipsController extends AbstractController
    query: (request, response, next) ->
      Membership
        .find(league: request.params.id)
        .populate('league', 'name description _id')
        .populate('player', 'name email _id')
        .sort('-rating')
        .lean()
        .exec (err, memberships) ->
          response.json memberships

  LeagueMembershipsController.getInstance()
