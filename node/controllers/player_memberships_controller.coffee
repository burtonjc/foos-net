define [
  'underscore'
  'models/membership'

], (_, Membership) ->

  query: (request, response, next) ->
    Membership
      .find(player: request.params.id)
      .lean()
      .exec (err, memberships) ->
        response.json memberships
